#!/usr/bin/env ruby
# coding: utf-8
$LOAD_PATH << File.expand_path('../../lib', __FILE__)
require 'roboparser'
require 'open-uri'
require 'addressable/uri'

require 'rest-client'
require 'vcr'
require 'curl'

require 'webmock/rspec'
VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.hook_into :webmock

end

url_='http://www.yandex.ru/'
#
VCR.use_cassette('yandex_hello',:serialize_with => :json,:preserve_exact_body_bytes => true)do

@uri=Addressable::URI.parse(url_).normalize

  begin
    open(@uri,'User-Agent'=>"Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20100101 Firefox/12.0 FirePHP/0.7.1")do |f|
      @status=f.status
      @html=f.read
      @meta=f.meta
      @base_uri=f.base_uri
    end
  rescue =>  e
  puts e.class

  end
end


