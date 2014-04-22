#!/usr/bin/env ruby
$LOAD_PATH << File.expand_path('../../lib', __FILE__)
require 'roboparser'

#require 'open-uri'
#require 'addressable/uri'

#require 'vcr'
#VCR.configure do |c|
#  c.cassette_library_dir = 'vcr_cassettes'
#  c.hook_into :webmock
#end
#VCR.use_cassette('google_visit') do
#url_='http://www.ya.ru/'
#@uri=Addressable::URI.parse(url_).normalize
#l=open(@uri,'User-Agent'=>"Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20100101 Firefox/12.0 FirePHP/0.7.1")
#@html=l.read
#@header=l.meta
#puts @header
#puts @html
#l.close
#end