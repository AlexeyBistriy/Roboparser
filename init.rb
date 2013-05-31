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


# запускаем стартовую страницу и читаем ее HTML код
client = Selenium::WebDriver::Remote::Http::Default.new
client.timeout = 180
watirff = Watir::Browser.new :ff, :http_client => client
watirff.goto "www.aliexpress.com"
html=watirff.html

# Прсим ссылки бокового меню
# xpatb для ссылок "//html/body/div[1]/div[3]/div[1]/div[1]/div/div[1]/div[1]/div/dl/dd/dl/dd/a"
tree_menu=TreeRefs.new
start_page=Parser.new
menu=start_page.navigate_xpath(html,"//html/body/div[1]/div[3]/div[1]/div[1]/div/div[1]/div[1]/div/dl/dd/dl/dd/a")
if debug
  tree_menu.puts_array_hashes(menu)
end

#переход на

# menu.each do |link|
#watirff.goto link[:href]
#
#end

watirff.goto menu[3][:href]

html=watirff.html
puts "<<<<<<<<<<<<<<<<<<<<<<<<<"+menu[3][:href]+">>>>>>>>>>>>>>>>>>>>>>>>>>"
page = Nokogiri::HTML(html)
data=[]
page.css(".list-item").each do |li|
  item=Hash.new
  item[:href_img] = li.css(".img a")[0][:href]
  item[:src_img]=li.css(".img img")[0][:src]
  item[:href_item]=li.css(".detail .history-item")[0][:href]
  item[:context_item]=li.css(".detail .history-item")[0].content
  item[:title_item]=li.css(".detail .history-item")[0][:title]
  item[:brief_item]=li.css(".detail .brief")[0].content
  item[:rate_item]=li.css("span[itemprop='ratingValue']")[0][:content]
  item[:rate_review]=li.css("span[itemprop='reviewCount']")[0][:content]
  item[:rate_feedback]=li.css(".rate-num")[0][:content]
  item[:rate_orders]=li.css("em[title='Total Orders']")[0][:content]


  data.push(item)
end
if debug
  tree_menu.puts_array_hashes(data)
end