# coding: utf-8
require 'spec_helper'

#describe "#list_servers" do
#  it "default" do
#    @loader=Loader.new
#    @loader.list_servers.should include('Google'=>'https://www.google.com',
#                                        'Yandex'=>'http://yandex.ua',
#                                        'Rambler'=>'http://www.rambler.ru/',
#                                        'Yahoo'=>'https://www.yahoo.com/',
#                                        'Bing'=>'https://www.bing.com/',
#                                        'DuckDuckGo'=>'https://duckduckgo.com/')
#  end
#end


module Roboparser
 describe Loader do
    before(:each) do

      @loader=Loader.new
    end
    context '#visit' do
      it 'server available' do
         @host=Host.new(name:'Yandex',url:'http://www.yandex.ru/')
         #stub_request(:get, @host.uri).\
         #  with(:headers => {'Accept'=>'*/*', 'User-Agent'=>\
         #  'Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20100101 Firefox/12.0 FirePHP/0.7.1'}).\
         #  to_return(:status => ["200", "Ok"], :body => "", :headers => {})

         canned_response = File.new 'spec/vcr_cassettes/yandex_hello.yml'
         stub_request(:get, @host.url).to_return(canned_response)

         @loader.visit(@host)
         @loader.status.should ==  ["200", "Ok"]
       it 'yiald'do
         @host=Host.new(name:'Yandex',url:'http://www.yandex.ru/')
         #stub_request(:get, @host.uri).\
         #  with(:headers => {'Accept'=>'*/*', 'User-Agent'=>\
         #  'Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20100101 Firefox/12.0 FirePHP/0.7.1'}).\
         #  to_return(:status => ["200", "Ok"], :body => "", :headers => {})

         canned_response = File.new 'spec/vcr_cassettes/yandex_hello.yml'
         stub_request(:get, @host.url).to_return(canned_response)
         lumb=false
         @loader.visit(@host,lambda{})
         @loader.status.should ==  ["200", "Ok"]
       end

      end

      #it 'server pege not found' do
      #  @host=Host.new(name:'Yandex',url:'http://www.yandex.ru/rupt')
      #  canned_response = File.new 'spec/vcr_cassettes/yandex_OpenURI_HTTPError.yml'
      #  stub_request(:get, @host.uri).to_return(canned_response)
      #  @loader.visit(@host)
      #  #expect{@loader.visit(@host)}.to raise_error(OpenURI::HTTPError)
      #  @loader.status.should == 400
      #
      #end

    end
 end

end


