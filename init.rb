# Парсим сайт www.aliexpress.com



require "watir-webdriver"
require 'nokogiri'
require_relative "Parser"
require_relative "tree_refs"

client = Selenium::WebDriver::Remote::Http::Default.new
client.timeout = 180
watirff = Watir::Browser.new :ff, :http_client => client
watirff.goto "www.aliexpress.com"

# ----------------------------  1
#startTime=Time.new.to_f

# test time

#puts (Time.new.to_f-startTime)

# ----------------------------- 2

startTime=Time.new.to_f

html=watirff.html
tree=TreeRefs.new
#tree.view_links(html)
#tree.view_navigate(html,"//html/body/div[1]/div[3]/div[1]/div[1]/div/div[1]/div[1]/div/dl/dd/dl/dd/a")
puts (Time.new.to_f-startTime)



#step=1
#  File.open('sleep'+"#{step}"+'.txt', 'w'){ |file| file.write watirff.html }
#step+=1
#  File.open('sleep'+"#{step}"+'.txt', 'w'){ |file| file.write watirff.as}
#step+=1
#  File.open('sleep'+"#{step}"+'.txt', 'w'){ |file| file.write watirff.divs}
#step+=1
#  File.open('sleep'+"#{step}"+'.txt', 'w'){ |file| file.write watirff.as}
