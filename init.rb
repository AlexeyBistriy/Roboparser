# Парсим сайт www.aliexpress.com с помощью связки Nokogiri&Watir

#startTime=Time.new.to_f

# test time

#puts (Time.new.to_f-startTime)

# ----------------------------- 2


#step=1
#  File.open('sleep'+"#{step}"+'.txt', 'w'){ |file| file.write watirff.html }
#step+=1
#  File.open('sleep'+"#{step}"+'.txt', 'w'){ |file| file.write watirff.as}
#step+=1
#  File.open('sleep'+"#{step}"+'.txt', 'w'){ |file| file.write watirff.divs}
#step+=1
#  File.open('sleep'+"#{step}"+'.txt', 'w'){ |file| file.write watirff.as}



require "watir-webdriver"
require 'nokogiri'
require_relative "Parser"
require_relative "tree_refs"

debug=true
error=0
dump=0



# запускаем стартовую страницу и читаем ее HTML код

parser=ParserWatir.new #("http://www.aliexpress.com/")
parser.goto("http://www.aliexpress.com/")
if  parser.url=="http://www.aliexpress.com/homeRu.htm"
  menu=parser.css_a(".cate-list-item")
  version=1
elsif parser.url=="http://www.aliexpress.com/"
  menu=parser.xpath_a("//html/body/div[1]/div[3]/div[1]/div[1]/div/div[1]/div[1]/div/dl/dd/dl/dd/a")
  version=2
end

menu.each_index do |index|
  link=menu[index]
  next_href=link[:href]
  next if index < dump
  while next_href!=""
    begin
      parser.goto(next_href)
    rescue Timeout::Error
      error+=1
      File.open('error.txt', 'a'){|file| file.write "error #{error.to_s} no download URL= #{next_href}"}
      File.open('dump.txt', 'w'){|file| file.write "#{index}:#{link[:href]}:#{next_href}"}
      dump = index
    end


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
      #case version
      #when 1
      #  puts  "="+item[:currency]=parser.css_no_nil(li,".price-m .currency","content")
      #  puts  "="+item[:price]=parser.css_no_nil(li,".price-m em","content")
      #  puts  "="+item[:unit]=parser.css_no_nil(li,".price-m .unit","content")
      #when 2
        puts  "="+item[:currency]=parser.css_no_nil(li,".price-m span[itemprop='priceCurrency']","content")
        puts  "="+item[:price]=parser.css_no_nil(li,".price-m span[itemprop='price']","content")
        puts  "="+item[:unit]=parser.css_no_nil(li,".price-m .unit","content")
      #end
      #puts  "="+item[:cur]=parser.css_no_nil(li,".pnl-shipping .unit","content")
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
      # сохранение в масив
      #data.push(item)
      #запись в файл разделитель;

      File.open("./data/#{link[:content].gsub(/\&/," ")}.txt", 'a'){|file| file.write item.values.join("	")+"\n"}

    end

    next_href=parser.css_no_nil(parser.page,".page-next",:href)
    #next_href=""
  end


end
File.open('dump.txt', 'w'){|file| file.write ""}
