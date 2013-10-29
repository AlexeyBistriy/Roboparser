# coding: utf-8

require 'net/https'
require 'net/http'
require 'open-uri'
require 'nokogiri'
require 'watir-webdriver'
require 'rubygems'
require 'net/smtp'
require 'csv'
require_relative 'parser'


module OpenSSL
  module SSL
    remove_const :VERIFY_PEER
  end
end
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

module Robot
  #name,parse_method,key_parse,attribute,element_index=0
  path="./data/"
  file_output='baza.csv'
  url="https://www.fl.ru/?page=2&kind=5"
  key_word=['парсер','парсить','программист'].join('|')
  block_record=Record.new
  block_record.name='block'
  block_record.method='css'
  block_record.key="div#projects-list div"
  block_record.index=nil
  block_record.attribute=nil
  dset=Data_set.new
  dset.add('title','css','.b-post__title a','content')
  dset.add('link','css','.b-post__title a','href')
  dset.add('price','css','.b-post__price','content')
  dset.add('task','css','.b-post__body','content')
  dset.data_puts
  loader=Loader.new
  loader.goto(url)
  parser=NokoParser.new
  parser.document(loader.html)
  page=parser.page
  nodes_blocks=parser.nodes_by_record(page,block_record)
  nodes_blokck_array=parser.regex(nodes_blocks,'id',/project-item\d+/)
  nodes_blokck_array.each do |block|
    dset.values=parser.attribute_by_data(parser.no_script(block),dset)
    #dset.save_to_file(path,file_output)
    if (dset.values[0]+dset.values[3])=~/#{key_word}/ui
      dset.send_to_mail(dset.values[1],dset.values[0]+dset.values[3])
    end
  end
end
