module Roboparser
  class Loader
    def initialize
      @list_servers={'Google'=>'https://www.google.com',
                    'Yandex'=>'http://yandex.ua',
                    'Rambler'=>'http://www.rambler.ru/',
                    'Yahoo'=>'https://www.yahoo.com/',
                    'Bing'=>'https://www.bing.com/',
                    'DuckDuckGo'=>'https://duckduckgo.com/'}
    end
    attr_accessor :list_servers
  end
end