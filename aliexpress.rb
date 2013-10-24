# Парсим сайт www.aliexpress.com с помощью связки Nokogiri&Watir

#startTime=Time.new.to_f

# test time

#puts (Time.new.to_f-startTime)

# ----------------------------- 2

require 'open-uri'
require 'nokogiri'
require "watir-webdriver"
require_relative "parser"

debug=true
OS='Windows'

parser=Parser.new
parser.goto("http://www.aliexpress.com/")
menu=parser.css_a(".cate-list-item")
parser.read_from_dump

menu.each_index do |index|
  next if index < parser.dump_index
  parser.dump_index=index
  link=menu[index]
  if parser.no_dump
    next_href=link[:href]
  else
    next_href=parser.dump_url
    parser.no_dump=true
  end

  while next_href!=""
    if parser.goto(next_href)
      next_href=parser.css_no_nil(parser.page,".page-next",:href)
    else
      next_href=""
      next
    end
    parser.save_to_log
    #data=[]
    parser.page.css(".list-item").each do |li|
      item=Hash.new

      item[:qrdata]=li[:qrdata]
      item[:href_img]=parser.css_no_nil(li,".img a",:href,0)
      item[:src_img]=parser.css_no_nil(li,".img img",:src,0)
      item[:href_item]=parser.css_no_nil(li,".product",:href,0)
      item[:content_item]=parser.css_no_nil(li,".product","content",0)
      item[:title_item]=parser.css_no_nil(li,".product",:title,0)
      item[:brief_item]=parser.css_no_nil(li,".brief","content",0)
      item[:rate_item]=parser.css_no_nil(li,"span[itemprop='ratingValue']","content",0)
      item[:rate_review]=parser.css_no_nil(li,"span[itemprop='reviewCount']","content",0)
      item[:rate_feedback]=parser.css_no_nil(li,".rate-num","content",0)
      item[:rate_orders]=parser.css_no_nil(li,"em[title='Total Orders']","content",0)
      item[:currency]=parser.css_no_nil(li,".price-m span[itemprop='priceCurrency']","content",0)
      item[:price]=parser.css_no_nil(li,".price-m span[itemprop='price']","content",0)
      item[:unit]=parser.css_no_nil(li,".price-m .unit","content",0)
      item[:sheeping]=parser.css_no_nil(li,".pnl-shipping .price .value","content",0)
      item[:un]=parser.css_no_nil(li,".pnl-shipping .price .unit","content",0)
      item[:free]=parser.css_no_nil(li,".free-s","content",0)
      item[:via]=parser.css_no_nil(li,".pnl-shipping .price","content",0)
      item[:min_order]=parser.css_no_nil(li,".min-order","content",0)
      item[:store]=parser.css_no_nil(li,".store","content",0)
      item[:store_href]=parser.css_no_nil(li,".store",:href,0)
      item[:score_href]=parser.css_no_nil(li,".score-dot",:href,0)
      item[:positive]=parser.css_no_nil(li,".score-icon",:sellerpositivefeedbackpercentage,0)
      item[:score]=parser.css_no_nil(li,".score-icon",:feedbackscore,0)

      case OS
        when "Windows"
          File.open("./data/#{link[:content].gsub(/\&/," ")}.txt", 'a'){|file| file.write item.values.join("	")+"\n"}
        when "Unix"
          File.open("./data/#{link[:content].gsub(/\&/," ").encode('KOI8-R')}.txt", 'a'){|file| file.write item.values.join("	")+"\n"}
      end

    end

  end
end

