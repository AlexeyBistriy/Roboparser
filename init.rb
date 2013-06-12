# Парсим сайт www.aliexpress.com с помощью связки Nokogiri&Watir

#startTime=Time.new.to_f

# test time

#puts (Time.new.to_f-startTime)

# ----------------------------- 2

require 'open-uri'
require 'nokogiri'
require "watir-webdriver"
require_relative "parser"
require_relative "parserwatir"


#debug=true
parser=Parser.new
parser.goto("http://www.aliexpress.com/")
menu=parser.css_a(".cate-list-item")
parser.read_from_dump

menu.each_index do |index|
  next if index < parser.dump
  link=menu[index]
  if parser.no_error
    next_href=link[:href]
  else
    next_href=parser.dump_url
  end

  while next_href!=""
    parser.dump = index
    parser.goto(next_href)
    #data=[]
    parser.page.css(".list-item").each do |li|
      item=Hash.new

      item[:qrdata]=li[:qrdata]
      item[:href_img]=parser.css_no_nil(li,".img a",:href)
      item[:src_img]=parser.css_no_nil(li,".img img",:src)
      item[:href_item]=parser.css_no_nil(li,".product",:href)
      item[:content_item]=parser.css_no_nil(li,".product","content")
      item[:title_item]=parser.css_no_nil(li,".product",:title)
      item[:brief_item]=parser.css_no_nil(li,".brief","content")
      item[:rate_item]=parser.css_no_nil(li,"span[itemprop='ratingValue']","content")
      item[:rate_review]=parser.css_no_nil(li,"span[itemprop='reviewCount']","content")
      item[:rate_feedback]=parser.css_no_nil(li,".rate-num","content")
      item[:rate_orders]=parser.css_no_nil(li,"em[title='Total Orders']","content")
      item[:currency]=parser.css_no_nil(li,".price-m span[itemprop='priceCurrency']","content")
      item[:price]=parser.css_no_nil(li,".price-m span[itemprop='price']","content")
      item[:unit]=parser.css_no_nil(li,".price-m .unit","content")
      item[:sheeping]=parser.css_no_nil(li,".pnl-shipping .price .value","content")
      item[:un]=parser.css_no_nil(li,".pnl-shipping .price .unit","content")
      item[:free]=parser.css_no_nil(li,".free-s","content")
      item[:via]=parser.css_no_nil(li,".pnl-shipping .price","content")
      item[:min_order]=parser.css_no_nil(li,".min-order","content")
      item[:store]=parser.css_no_nil(li,".store","content")
      item[:store_href]=parser.css_no_nil(li,".store",:href)
      item[:score_href]=parser.css_no_nil(li,".score-dot",:href)
      item[:positive]=parser.css_no_nil(li,".score-icon",:sellerpositivefeedbackpercentage)
      item[:score]=parser.css_no_nil(li,".score-icon",:feedbackscore)


      File.open("./data/#{link[:content].gsub(/\&/," ")}.txt", 'a'){|file| file.write item.values.join("	")+"\n"}  if parser.no_error

    end

    next_href=parser.css_no_nil(parser.page,".page-next",:href) if parser.no_error
    #next_href=""
  end
end
File.open('dump.txt', 'w'){|file| file.write ""}
