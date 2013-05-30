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
  tree_menu.puts_links(menu)
end

#переход на

# menu.each do |link|
#watirff.goto link[:href]
#
#end

watirff.goto menu[3][:href]
html=watirff.html
