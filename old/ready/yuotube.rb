require 'rubygems'
require 'nokogiri'
require 'open-uri'

urls = []

#pass the search terms here
search_list = ["football", "manchester united", "amazing tennis", "radical something", "Just for Laugh"]

search_list.each do |search_term|
  list_url = "http://www.youtube.com/results?search_query=#{search_term.split(' ').join('+')}"

  page = Nokogiri::HTML(open (list_url))
  p '-------------------------------------------------------------------------'
  p "finding videos for #{search_term}"

  div_elements = page.css('li.yt-lockup2 a')

  div_elements.each do |d|
    watch_code = d.attributes['href'].value
    urls << "http://www.youtube.com" + watch_code if watch_code.include?('watch')
  end

  p 'the links are'
  p urls
  p 'total videos found'
  p urls.count

  p '---------------download start -----------------------------------------------'
  urls.each do |link_to_video|
    system("youtube-dl -t #{link_to_video}")
  end
  p '---------------download completed-------------------------------------------'
end
