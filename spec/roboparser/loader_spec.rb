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
  describe "Connect to the server via http"do
    before(:each) do
      @host=Host.new(name:'Yandex',url:'http://yandex.ua/yandsearch?lr=142&text=привет')
    end
    describe Host do
      context "#name" do
        it "name" do
          @host.name.should == "Yandex"
        end
      end
      context "#url" do
        it "url" do
          @host.url.should == 'http://yandex.ua/yandsearch?lr=142&text=привет'
        end
      end
      context "#uri" do
        it "uri to_s" do
          @host.uri.should be_a_instance_of('Addressable::URI')
          @host.uri.to_s.should == "http://yandex.ua/yandsearch?lr=142&text=%D0%BF%D1%80%D0%B8%D0%B2%D0%B5%D1%82"
        end
      end
    end
    #describe Loader do
    #  before(:each)do
    #     @loader=Loader.new
    #  end
    #  context '#visit' do
    #    it 'server available' do
    #       @loader.visit(@host)
    #       @loader.status_code.should =~ /20./
    #    end
    #    it 'server unavailable' do
    #      expect{@loader.visit(@host)}.to raise_error("Error")
    #      @loader.status_code.should =~ /40./
    #    end
    #
    #  end
    #end
  end
end


