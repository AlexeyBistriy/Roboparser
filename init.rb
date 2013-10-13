# coding: utf-8
# Парсим сайт Free-lance

#startTime=Time.new.to_f

# test time

#puts (Time.new.to_f-startTime)

# ----------------------------- 2

require 'open-uri'
require 'nokogiri'
require "watir-webdriver"
require 'rubygems'
require 'net/smtp'
require_relative "parser"
require_relative "parserwatir"

debug=true
OS='Windows'
key_word=["ruby","парсер","парсить"]
parser=ParserWatir.new
parser.goto("https://www.fl.ru/")
#menu=parser.page.css("div#projects-list").xpath('./div')
#menu=parser.page.css("div#projects-list div").find_all{|div| div["id"]=~/project-item\d+/}

projects=parser.page.css('div:psevdoclass("project-item\d+")', Class.new{
  def psevdoclass node_set, regex
    node_set.find_all{|node| node["id"]=~/#{regex}/}
  end
}.new)
projects.each do |job|
  task=Hash.new
  job["id"]=~/project-item(\d+)/
  task[:id]= Regexp.last_match[1]
  task[:price]= job.css(".b-post__price")[0].content
  task[:title]= job.css(".b-post__title a")[0].content
  task[:href]= job.css(".b-post__title a")[0][:href]
  task[:content]= job.css(".b-post__body")[0].content

  if task[:content]=~/ruby|парсер|парсить|программист/
      puts "++++++++++++++++++++++++++++++++++++++++++"
      puts task[:id]
      puts task[:price]
      puts task[:title]
      puts task[:href]
      puts task[:content]

      from = 'newsvin@ukr.net'
      to = 'alexeybistriy@gmail.com'
      theme = task[:href]
      text=task[:content]
      message=""
      message<<"From: ot kogo <#{from}>\n"
      message<<"To: #{to}\n"
      message<<"Subject: #{theme}\n"
      message<<text
      smtp=Net::SMTP.new('smtp.ukr.net',465)
      smtp.enable_tls
      smtp.start('localhost','newsvin@ukr.net','xxxxxxxxx',:plain) do |smtp|
        smtp.send_message message, from, to
      end
      #to_  sms(task[:href])
  end
end




