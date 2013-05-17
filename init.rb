# Парсим сайт www.aliexpress.com
require "watir-webdriver"
require_relative "Parser"
watirff= Watir::Browser.new :ff
watirff.goto "www.aliexpress.com"
#watirff.goto "www.mail.ru"
ali=Parser.new

# ----------------------------  1
#startTime=Time.new.to_f
#parser_as=ali.links(watirff)
#parser_as.each do |link|
#  puts link
#end
#  puts parser_as.size
#
#puts (Time.new.to_f-startTime)

# ----------------------------- 2
#puts startTime=Time.new.to_f
#parser_as=ali.links2(watirff)
#parser_as.each do |link|
#  puts link
#  puts ali.href(link)
#end
#puts parser_as.size
#
#puts (Time.new.to_f-startTime)

puts startTime=Time.new.to_f
parser_as=ali.imgs(watirff)
parser_as.each do |link|
  puts link
  puts ali.href(link)
end
puts parser_as.size

puts (Time.new.to_f-startTime)
#step=1
#  File.open('sleep'+"#{step}"+'.txt', 'w'){ |file| file.write watirff.html }
#step+=1
#  File.open('sleep'+"#{step}"+'.txt', 'w'){ |file| file.write watirff.as}
#step+=1
#  File.open('sleep'+"#{step}"+'.txt', 'w'){ |file| file.write watirff.divs}
#step+=1
#  File.open('sleep'+"#{step}"+'.txt', 'w'){ |file| file.write watirff.as}




