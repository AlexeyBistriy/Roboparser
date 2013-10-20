# coding: utf-8
# Парсим сайт Free-lance

#startTime=Time.new.to_f

# test time

#puts (Time.new.to_f-startTime)

# ----------------------------- 2

require 'net/https'
require 'net/http'
require 'open-uri'
require 'nokogiri'
require "watir-webdriver"
require 'rubygems'
require 'net/smtp'
#require 'openssl'
require_relative "parser"
require_relative "parserwatir"
module OpenSSL
  module SSL
    remove_const :VERIFY_PEER
  end
end
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
module Robot
  DEBUG=true
  OS='Windows'
  WATIR_PARSER=false
  key_word=["","парсер","парсить","VBA","нужен"].join("|")
  url="https://www.fl.ru/?page=2&kind=5"

  if WATIR_PARSER
    parser=ParserWatir.new
  else

    parser=Parser.new
  end


  parser.goto(url)

  #ПРимер
  # menu=parser.page.css("div#projects-list").xpath('./div')
  # Пример использования псевдокласса CSS с регулярнім выражением
  #projects=parser.page.css('div:psevdoclass("project-item\d+")', Class.new{
  #  def psevdoclass node_set, regex
  #    node_set.find_all{|node| node["id"]=~/#{regex}/}
  #  end
  #}.new)

  projects=parser.page.css("div#projects-list div").find_all{|div| div["id"]=~/project-item\d+/}
  projects.each do |job|
    task=Hash.new
    job["id"]=~/project-item(\d+)/
    task[:id]= Regexp.last_match[1]

    task[:title]= parser.css_no_nil(job,".b-post__title a","content",0)
    task[:href]= parser.css_no_nil(job,".b-post__title a",:href,0)
    script=parser.css_no_nil(job,"script","content",0)
    newjob=parser.script_to_nodeset(script)
    task[:price]=parser.css_no_nil(newjob,".b-post__price","content",0)
    script=parser.css_no_nil(job,"script","content",1)
    newjob=parser.script_to_nodeset(script)
    task[:content]=parser.css_no_nil(newjob,".b-post__body","content",0)

    #puts "============================================"
    #puts task[:id]
    #puts task[:price]
    #puts task[:title]
    #puts task[:href]
    #puts task[:content]


    if task[:title]+task[:content]=~/#{key_word}/ui
        if DEBUG
          puts "+++++++++++++++++++++++++++++++++++++++++++++"
          puts task[:id]
          puts task[:price]
          puts task[:title]
          puts task[:href]
          puts task[:content]
        end
        from = 'newsvin@ukr.net'
        to = 'alexeybistriy@gmail.com'
        theme = task[:href]
        text=task[:title]+task[:content]
        message=""
        message<<"From: My Rorbo <#{from}>\n"
        message<<"To: Alexey Bistriy <#{to}>\n"
        message<<"Subject: #{theme}\n"
        message<<text
        smtp=Net::SMTP.new('smtp.ukr.net',465)
        smtp.enable_tls
        #smtp.start('localhost','newsvin@ukr.net','VVVVV',:plain) do |smtp|
        #  smtp.send_message message, from, to
        #end
    end
  end
end

