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
  describe Host do
    before(:each) do
      @host=Host.new(name:'Google',url:'http://www.google.com/')
    end
    context "#name" do
      it "name" do
        @host.name.should == "Google"
      end
    end
    context "#url" do
      it "url" do
        @host.url.should == "http://www.google.com/"
      end
    end
  end
  describe Loader do
    before(:each) do
      @host=Host.new(name:'Google',url:'http://www.google.com/')

    end
    context '#visit' do
      it 'server available' do
        stub_request(:get,@host).to
      end
      it "server unavailable" do

      end
    end
  end
end


