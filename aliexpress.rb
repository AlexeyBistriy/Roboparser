# coding: utf-8
#http://www.rsdn.ru/article/ruby/ruby_edges.xml
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
  file_output='baza.cvs'
  url="http://www.aliexpress.com/"
  path="./data/"
  #key_word=["парсер","парсить","программист"].join("|")

  menu=Menu.new

  #Selector page Menu
  menu_record=Record.new
  menu_record.name='menu'
  menu_record.method='css'
  menu_record.key='.cate-list a'
  menu_record.index=nil
  menu_record.attribute=nil

  #menu_set=Data_set.new
  #menu_set.add('title','css','a','content')
  #menu_set.add('link','css','a','href')

  # selector next page
  next_page=Record.new
  next_page.name='Next'
  next_page.method='css'
  next_page.key='.page-next'
  next_page.index=0
  next_page.attribute='href'



  # page data

  block_record=Record.new
  block_record.name='block'
  block_record.method='css'
  block_record.key='.list-item'
  block_record.index=nil
  block_record.attribute=nil

  d_set=Data_set.new
  d_set.add('qrdata','attribute',"",'qrdata')
  d_set.add('href_img','css','.img a','href')
  d_set.add('src_img','css','.img img','src')
  d_set.add('href_item','css','.product','href')
  d_set.add('content_item','css','.product','content')
  d_set.add('title_item','css','.product','title')
  d_set.add('brief_item','css','.brief','content')
  d_set.add('rate_item','css',"span[itemprop='ratingValue']",'content')
  d_set.add('rate_review','css',"span[itemprop='reviewCount']",'content')
  d_set.add('rate_feedback','css','.rate-num','content')
  d_set.add('rate_orders','css',"em[title='Total Orders']",'content')
  d_set.add('currency','css',".price-m span[itemprop='priceCurrency']",'content')
  d_set.add('price','css',".price-m span[itemprop='price']",'content')
  d_set.add('unit','css','.price-m .unit','content')

  d_set.add('sheeping','css','.pnl-shipping .price .value','content')
  d_set.add('un','css','.pnl-shipping .price .unit','content')
  d_set.add('free','css','.free-s','content')
  d_set.add('via','css','.pnl-shipping .price','content')

  d_set.add('min_order','css','.free-s','content')
  d_set.add('store','css','.store','content')
  d_set.add('store_href','css','.store','href')
  d_set.add('score_href','css','.score-dot','href')
  d_set.add('positive','css','.score-icon','sellerpositivefeedbackpercentage')
  d_set.add('scoref','css','.score-icon','feedbackscore')


  loader=Loader.new
  if loader.goto(url) then
    parser=NokoParser.new
    parser.document(loader.html)
    page=parser.page
    menu_nodes=parser.nodes_by_record(page,menu_record)
    menu.add(menu_nodes,/\/category\//)
    menu.save_to_file('menu.csv')

    menu.tree.each do |item|
      loader.goto(item[:href])
      parser.document(loader.html)
      page=parser.page
      next_url=parser.attribute_by_record(page,next_page)

      nodesblocks=parser.nodes_by_record(page,block_record)
      d_set.head_save_to_file(path,item[:content])
      nodesblocks.each do |nodesblock|
        d_set.values=parser.attribute_by_data(nodesblock,d_set)
        d_set.save_to_file(path,item[:content])
      end

      while next_url!=''
        loader.goto(next_url)
        parser.document(loader.html)
        page=parser.page
        nodesblocks=parser.nodes_by_record(page,block_record)
        nodesblocks.each do |nodesblock|
          d_set.values=parser.attribute_by_data(nodesblock,d_set)
          d_set.save_to_file(path,item[:content])
        end
        next_url=parser.attribute_by_record(page,next_page)
      end
    end
  else
    puts "Стартовая страница #{url} не загружается"
  end
end

