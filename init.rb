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
require "csv"
require_relative "parser"
require_relative "parserwatir"

module OpenSSL
  module SSL
    remove_const :VERIFY_PEER
  end
end
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

module Robot


  #name,parse_method,key_parse,attribute,element_index=0
  file_output="baza.cvs"
  url="https://www.fl.ru/?page=2&kind=5"

  block=Record.new
    block.name="block"
    block.method="css"
    block.key="div#projects-list div"
    block.index=nil
    block.attribute=nil
  dset=Data_set.new
  dset.add("title","css",".b-post__title a","content")
  dset.add("link","css",".b-post__title a","href")
  dset.add("price","css",".b-post__price","content")
  dset.add("task","css",".b-post__body","content")
  dset.data_puts
  loader=Loader.new
  loader.goto(url)
  parser=NokoParser.new
  parser.parse_page(loader.html)
  blocks=parser.cut_blocks(parser.page,block)
  blocks=parser.regex(blocks,"id",/project-item\d+/)
  blocks.each do |block|
    dset.data_puts
    dset.data=parser.by_data(parser.no_script(block),dset.data)
    dset.data_puts
    dset.save_to_file(file_output)
    dset.send_to_mail(dsat.data[],body,email)

    #if task[:title]+task[:content]=~/#{key_word}/ui
    #  if DEBUG
    #    puts "+++++++++++++++++++++++++++++++++++++++++++++"
    #    puts task[:id]
    #    puts task[:price]
    #    puts task[:title]
    #    puts task[:href]
    #    puts task[:content]
    #  end
    #  from = 'newsvin@ukr.net'
    #  to = 'alexeybistriy@gmail.com'
    #  theme = task[:href]
    #  text=task[:title]+task[:content]
    #  message=""
    #  message<<"From: My Rorbo <#{from}>\n"
    #  message<<"To: Alexey Bistriy <#{to}>\n"
    #  message<<"Subject: #{theme}\n"
    #  message<<text
    #  smtp=Net::SMTP.new('smtp.ukr.net',465)
    #  smtp.enable_tls
    #  #smtp.start('localhost','newsvin@ukr.net','VVVVV',:plain) do |smtp|
    #  #  smtp.send_message message, from, to
    #  #end
    #end
  end

end
#
#end
