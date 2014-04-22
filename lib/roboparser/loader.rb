# coding: utf-8
module Roboparser
  class Loader
    def initialize

    end
    def visit(host)

      l=open(@uri,'User-Agent'=>"Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20100101 Firefox/12.0 FirePHP/0.7.1")
      @html=l.read
      @header=l.meta
      puts @header
      puts @html
      l.close
    end
  end
class Host
  def initialize(options)
    @name=options[:name]
    @url=options[:url]
    @uri=Addressable::URI.parse(@url).normalize
  end
  attr_reader :name, :url,:uri

end
end