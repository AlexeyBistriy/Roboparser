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
require_relative "tree_refs"

debug=true

parser=Parser.new
parser.goto("http://www.aliexpress.com/")
menu=parser.css_a(".cate-list-item")
parser.read_from_dump

menu.each_index do |index|
  link=menu[index]
  next_href=link[:href]
  next if index < parser.dump
  while next_href!=""
    parser.dump = index
    parser.goto(next_href)
    #data=[]
    parser.page.css(".list-item").each do |li|
      item=Hash.new
      puts "{{{{{{{{{{{{{{{{{{{{{{{{{{"
      puts "="+item[:qrdata]=li[:qrdata]
      puts "="+item[:href_img]=parser.css_no_nil(li,".img a",:href)
      puts "="+item[:src_img]=parser.css_no_nil(li,".img img",:src)
      puts "="+item[:href_item]=parser.css_no_nil(li,".product",:href)
      puts "="+ item[:content_item]=parser.css_no_nil(li,".product","content")
      puts  "="+item[:title_item]=parser.css_no_nil(li,".product",:title)
      puts  "="+item[:brief_item]=parser.css_no_nil(li,".brief","content")
      puts  "="+item[:rate_item]=parser.css_no_nil(li,"span[itemprop='ratingValue']","content")
      puts "="+ item[:rate_review]=parser.css_no_nil(li,"span[itemprop='reviewCount']","content")
      puts  "="+item[:rate_feedback]=parser.css_no_nil(li,".rate-num","content")
      puts  "="+item[:rate_orders]=parser.css_no_nil(li,"em[title='Total Orders']","content")
      puts  "="+item[:currency]=parser.css_no_nil(li,".price-m span[itemprop='priceCurrency']","content")
      puts  "="+item[:price]=parser.css_no_nil(li,".price-m span[itemprop='price']","content")
      puts  "="+item[:unit]=parser.css_no_nil(li,".price-m .unit","content")
      puts  "="+item[:sheeping]=parser.css_no_nil(li,".pnl-shipping .price .value","content")
      puts  "="+item[:un]=parser.css_no_nil(li,".pnl-shipping .price .unit","content")
      puts  "="+item[:free]=parser.css_no_nil(li,".free-s","content")
      puts  "="+item[:via]=parser.css_no_nil(li,".pnl-shipping .price","content")
      puts  "="+item[:min_order]=parser.css_no_nil(li,".min-order","content")
      puts  "="+item[:store]=parser.css_no_nil(li,".store","content")
      puts  "="+item[:store_href]=parser.css_no_nil(li,".store",:href)
      puts  "="+item[:score_href]=parser.css_no_nil(li,".score-dot",:href)
      puts  "="+item[:positive]=parser.css_no_nil(li,".score-icon",:sellerpositivefeedbackpercentage)
      puts  "="+item[:score]=parser.css_no_nil(li,".score-icon",:feedbackscore)
      puts ")))))))))))))))))))))))))))))))"

      File.open("./data/#{link[:content].gsub(/\&/," ")}.txt", 'a'){|file| file.write item.values.join("	")+"\n"}

    end
    next_href=parser.css_no_nil(parser.page,".page-next",:href)
    #next_href=""
  end
end
File.open('dump.txt', 'w'){|file| file.write ""}
