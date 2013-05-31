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
if  watirff.url=="http://www.aliexpress.com/homeRu.htm"
  menu=start_page.navigate_css(html,".cate-list-item")
elsif watirff.url=="http://www.aliexpress.com/"
  menu=start_page.navigate_xpath(html,"//html/body/div[1]/div[3]/div[1]/div[1]/div/div[1]/div[1]/div/dl/dd/dl/dd/a")
end

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
  unless (tmp=li.css(".img a")).empty?
    item[:href_img] = tmp[0][:href]
  end
  unless (tmp=li.css(".img img")).empty?
    item[:src_img]=tmp[0][:src]
  end
  unless (tmp=li.css(".history-item")).empty?
    item[:href_item]=tmp[0][:href]
    item[:context_item]=tmp[0].content
    item[:title_item]=tmp[0][:title]
  end
  unless (tmp=li.css(".brief")).empty?
    item[:brief_item]=tmp[0].content
  end
  unless (tmp=li.css("span[itemprop='ratingValue']")).empty?
    item[:rate_item]=tmp[0][:content]
  end
  unless (tmp=li.css("span[itemprop='reviewCount']")).empty?
    item[:rate_review]=tmp[0][:content]
  end
  unless (tmp=li.css(".rate-num")).empty?
    item[:rate_feedback]=tmp[0][:content]
  end

  unless (tmp=li.css("em[title='Total Orders']")).empty?
    item[:rate_orders]=tmp[0][:content]
  end
  unless (tmp=li.css(".price-m .currency")).empty?
    item[:currency]=tmp[0][:content]
  end
  unless (tmp=li.css(".price-m .value")).empty?
    item[:price]=tmp[0][:content]
  end
  unless (tmp=li.css(".price-m .unit")).empty?
    item[:unit]=tmp[0][:content]
  end
  unless (tmp=li.css(".pnl-shipping .currency")).empty?
    item[:cur]=tmp[0][:content]
  end
  unless (tmp=li.css(".price .value")).empty?
    item[:sheeping]=tmp[0][:content]
  end
  unless (tmp=li.css(".price .unit")).empty?
    item[:un]=tmp[0][:content]
  end
  unless (tmp=li.css(".free-s")).empty?
    item[:free]=tmp[0][:content]
  end

  data.push(item)
end
if debug
  tree_menu.puts_array_hashes(data)
end