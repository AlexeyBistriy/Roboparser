#!/usr/bin/env ruby
# coding: utf-8
$LOAD_PATH << File.expand_path('../../lib', __FILE__)
require 'roboparser'
require 'open-uri'
require 'addressable/uri'

require 'rest-client'
require 'vcr'
#require 'webmock/rspec'
#VCR.configure do |c|
#  c.cassette_library_dir = 'spec/vcr_cassettes'
#  c.hook_into :webmock
#end
#module Tst
#url_='http://www.yandex.ru/'
#
##VCR.use_cassette('yandex_OpenURI_HTTPError')do
#
#@uri=Addressable::URI.parse(url_).normalize
#
#begin
#  f=open(@uri,'User-Agent'=>"Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20100101 Firefox/12.0 FirePHP/0.7.1")
#    @status_code= f.status
#    @meta=f.meta
#    @html=f.read
#    f.close
#rescue =>  e
#puts e.class
#
#end
#end


canned_response = File.new ''