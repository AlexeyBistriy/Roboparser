module Roboparser
  class Loader
    def initialize
      #@host_name=''
      #@list_servers={'Google'=>'https://www.google.com',
      #              'Yandex'=>'http://yandex.ua',
      #              'Rambler'=>'http://www.rambler.ru/',
      #              'Yahoo'=>'https://www.yahoo.com/',
      #              'Bing'=>'https://www.bing.com/',
      #              'DuckDuckGo'=>'https://duckduckgo.com/'}
    end
    def host_name
      @host_name
    end
    def host_name=(name)
      @host_name=name
    end
    def host_url
      @host_url
    end
    def host_url=(url)
      @host_url=url
    end
  end
end