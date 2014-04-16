require 'spec_helper'
module Roboparser

  describe Loader do
    describe "#list_servers" do
      it "default" do
        @loader=Loader.new
        @loader.list_servers.should include('Google'=>'https://www.google.com',
                                            'Yandex'=>'http://yandex.ua',
                                            'Rambler'=>'http://www.rambler.ru/',
                                            'Yahoo'=>'https://www.yahoo.com/',
                                            'Bing'=>'https://www.bing.com/',
                                            'DuckDuckGo'=>'https://duckduckgo.com/')
      end
    end
  end
end
