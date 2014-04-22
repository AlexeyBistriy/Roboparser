#!/usr/bin/env ruby
# coding: utf-8
$LOAD_PATH << File.expand_path('../../lib', __FILE__)
require 'roboparser'
require 'open-uri'
require 'addressable/uri'
require 'vcr'
require 'rest-client'

#VCR.configure do |c|
#  c.cassette_library_dir = 'vcr_cassettes'
#  c.hook_into :webmock
#end
url_='http://yandex.ua/yandsearch?lr=142&text=привет'

VCR.use_cassette('yandex_hello_200')do

@uri=Addressable::URI.parse(url_).normalize
l=open(@uri,'User-Agent'=>"Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20100101 Firefox/12.0 FirePHP/0.7.1")
@html=l.read
@header=l.meta
puts @header
puts @html
l.close
end
#VCR.use_cassette('rest_yandex_hello_404')do

#  @uri=Addressable::URI.parse(url_).normalize
#
#rest=RestClient.get(@uri.to_str,'User-Agent'=>"Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20100101 Firefox/12.0 FirePHP/0.7.1")
#@html=rest.body
#@header=rest.headers
#@code=rest.code
#@cookies=rest.cookies
#puts @header
#puts @html
##end