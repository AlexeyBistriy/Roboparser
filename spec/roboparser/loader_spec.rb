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
      it 'loads the web page' do
         @host=Host.new(name:'Yandex',url:'http://www.yandex.ru/')
         #canned_response = File.new 'spec/vcr_cassettes/foo.txt'
         #stub_request(:get, @host.uri).to_return(canned_response)
         VCR.use_cassette('yandex_hello') do
            @loader.visit(@host)
         end
         expect(@loader.status).to eq(["200", "Ok"])
       end
      it 'load page not found' do

        @host=Host.new(name:'Yandex',url:'http://www.yandex.ru/rupt')
        VCR.use_cassette('yandex_OpenURI_HTTPError') do
          expect(lambda{@loader.visit(@host)}).to raise_error(OpenURI::HTTPError)
          #expect(@loader.status).to eq(["205", "Ok"])

        end
      end
    end
 end
end


