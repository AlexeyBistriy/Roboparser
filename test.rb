#I am working on pioneer gem which is not a spider, but a simple asynchronous crawler based on em-synchrony gem
#https://github.com/fl00r/pioneer
#https://github.com/igrigorik/em-synchrony
#try to anemone
#http://anemone.rubyforge.org/
#You might want to check out wombat
#http://github.com/felipecsl/wombat
# http://ohler55.github.com/ox/
#Open-URI is good as a simple HTTP client, but it can get in the way when you want to do
#more complex things or need to have multiple requests firing at once. I'd recommend looking at
#HTTPClient or Typhoeus with Hydra for modest to heavyweight jobs. Curb is good too, because it
#uses the cURL library, but the interface isn't as intuitive to me. It's worth looking at though.
#HTTPclient is also worth looking at, but I lean toward the previously mentioned ones.

#If you are going to navigate sites in any way beyond simply grabbing pages and following links,
# you'll want to look at Mechanize. It makes it easy to fill out forms and submit pages.
#As an added bonus, you can grab the content of a page as a Nokogiri HTML document and parse away
#using Nokogiri's multitude of tricks.

#https://rubygems.org/gems/spider
#https://rubygems.org/gems/anemone

#http://www.danneu.com/posts/8-scraping-a-blog-with-anemone-ruby-web-crawler-and-mongodb/
#http://armoredcode.com/blog/create-a-quick-and-dirty-web-crawler-with-ruby/
#http://rishionrails.wordpress.com/2013/08/03/writing-a-web-parseror-a-web-crawler-in-ruby/
#http://www.skorks.com/2009/07/how-to-write-a-web-crawler-in-ruby/