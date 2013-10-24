# coding: utf-8

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
  key_word=["парсер","парсить","программист"].join("|")
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
    dset.data=parser.by_data(parser.no_script(block),dset.data)
    dset.save_to_file(file_output)
    if (dset.data[0].value+dset.data[3].value)=~/#{key_word}/ui
      dset.send_to_mail(dset.data[1].value,dset.data[0].value+dset.data[3].value)
    end
  end
end
