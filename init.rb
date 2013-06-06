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

def css_no_nil(li,css_in,attribute_in)
  css=li.css(css_in)
  unless css[0].nil?
    if attribute_in == "content"

        puts css[0].to_s

      css[0].content.gsub(/$\n?/," ")
    else
      css[0][attribute_in].gsub(/$\n?/," ")
    end
  else
    ""
  end
end



# запускаем стартовую страницу и читаем ее HTML код
client = Selenium::WebDriver::Remote::Http::Default.new
client.timeout = 380
watirff = Watir::Browser.new :ff, :http_client => client
watirff.goto "www.aliexpress.com"
html=watirff.html

# Прсим ссылки бокового меню
# xpatb для ссылок "//html/body/div[1]/div[3]/div[1]/div[1]/div/div[1]/div[1]/div/dl/dd/dl/dd/a"
tree_menu=TreeRefs.new
start_page=Parser.new
if  watirff.url=="http://www.aliexpress.com/homeRu.htm"
  menu=start_page.navigate_css(html,".cate-list-item")
elsif watirff.url=="http://www.aliexpress.com/"
  menu=start_page.navigate_xpath(html,"//html/body/div[1]/div[3]/div[1]/div[1]/div/div[1]/div[1]/div/dl/dd/dl/dd/a")
end

#if debug
#  tree_menu.puts_array_hashes(menu)
#end

#переход на

# menu.each do |link|
#watirff.goto link[:href]
#
#end

next_href=menu[3][:href]

while next_href!=""

watirff.goto  next_href

html=watirff.html
puts "<<<<<<<<<<<<<<<<<<<<<<<<<"+menu[3][:href]+">>>>>>>>>>>>>>>>>>>>>>>>>>"
page = Nokogiri::HTML(html)

#data=[]
page.css(".list-item").each do |li|
  item=Hash.new
  puts "{{{{{{{{{{{{{{{{{{{{{{{{{{"
  puts "="+item[:href_img]=css_no_nil(li,".img a",:href)
  puts "="+item[:src_img]=css_no_nil(li,".img img",:src)
  puts "="+item[:href_item]=css_no_nil(li,".product",:href)
  puts "="+ item[:content_item]=css_no_nil(li,".product","content")
  puts  "="+item[:title_item]=css_no_nil(li,".product",:title)
  puts  "="+item[:brief_item]=css_no_nil(li,".brief","content")
  puts  "="+item[:rate_item]=css_no_nil(li,"span[itemprop='ratingValue']","content")
  puts "="+ item[:rate_review]=css_no_nil(li,"span[itemprop='reviewCount']","content")
  puts  "="+item[:rate_feedback]=css_no_nil(li,".rate-num","content")
  puts  "="+item[:rate_orders]=css_no_nil(li,"em[title='Total Orders']","content")
  puts  "="+item[:currency]=css_no_nil(li,".price-m span[itemprop='priceCurrency']","content")
  puts  "="+item[:price]=css_no_nil(li,".price-m span[itemprop='price']","content")
  puts  "="+item[:unit]=css_no_nil(li,".price-m .unit","content")
  #puts  "="+item[:cur]=css_no_nil(li,".pnl-shipping .unit","content")
  puts  "="+item[:sheeping]=css_no_nil(li,".pnl-shipping .price .value","content")
  puts  "="+item[:un]=css_no_nil(li,".pnl-shipping .price .unit","content")
  puts  "="+item[:free]=css_no_nil(li,".free-s","content")
  puts  "="+item[:via]=css_no_nil(li,".pnl-shipping .price","content")
  puts ")))))))))))))))))))))))))))))))"
  # сохранение в масив
  #data.push(item)
  #запись в файл разделитель;

  File.open('sleep1.txt', 'a'){|file| file.write item.values.join(";")+"\n"}

end

next_href=css_no_nil(page,".page-next",:href)
end
if debug
  tree_menu.puts_array_hashes(data)
end