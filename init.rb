# Парсим сайт www.aliexpress.com
require "watir-webdriver"
require 'nokogiri'
require_relative "Parser"
watirff= Watir::Browser.new :ff
watirff.goto "www.aliexpress.com"
#watirff.goto "www.mail.ru"
ali=Parser.new

# ----------------------------  1
startTime=Time.new.to_f
html=watirff.html
parser_as=ali.nokogiri_links(html)
parser_as.each do |link|
  puts link
end
  puts parser_as.size

puts (Time.new.to_f-startTime)

# ----------------------------- 2
#puts startTime=Time.new.to_f
#parser_as=ali.reg_links(watirff)
#parser_as.each do |link|
#  puts link
#  puts ali.href(link)
#end
#puts parser_as.size
#
#puts (Time.new.to_f-startTime)
# ----------------------------------- 3
#puts startTime=Time.new.to_f
#parser_as=ali.watir_imgs(watirff)
#parser_as.each do |link|
#  puts link
#  puts ali.href(link)
#end
#puts parser_as.size
#
#puts (Time.new.to_f-startTime)
#
#startTime=Time.new.to_f
#html=watirff.html
#parser_as=ali.nokogiri_hrefs(html,0)
#parser_as.each do |link|
#  puts link["href"]
#  puts link["content"] #parser_as
#  puts link["level"]
#end
#  puts parser_as.size
#
#puts (Time.new.to_f-startTime)






#step=1
#  File.open('sleep'+"#{step}"+'.txt', 'w'){ |file| file.write watirff.html }
#step+=1
#  File.open('sleep'+"#{step}"+'.txt', 'w'){ |file| file.write watirff.as}
#step+=1
#  File.open('sleep'+"#{step}"+'.txt', 'w'){ |file| file.write watirff.divs}
#step+=1
#  File.open('sleep'+"#{step}"+'.txt', 'w'){ |file| file.write watirff.as}




