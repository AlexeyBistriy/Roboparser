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

    context "#host_name" do
      it "name" do
         loader=Loader.new
         loader.host_name="Google"
         loader.host_name.should == "google"
      end
      context "#host_url" do
        it "name" do
          loader=Loader.new
          loader.host_name="http://www.google.com/"
          loader.host_name.should == "http://www.google.com/"
        end
    end
  end
end


