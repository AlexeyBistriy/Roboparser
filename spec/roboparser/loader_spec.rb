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
         @host=Host.new(name:'Yandex',url:'http://yandex.ua/yandsearch?lr=142&text=привет')
         canned_response = File.new 'yandex_200.yaml'
         stub_request(:get, "http://yandex.ua/yandsearch?lr=142&text=привет").to_return(canned_response)
         @loader.visit(@host)
         @loader.status_code.should =~ /20./
      end
      it 'server unavailable' do
        expect{@loader.visit(@host)}.to raise_error("Error")
        @loader.status_code.should =~ /40./
      end

    end
  end
end


