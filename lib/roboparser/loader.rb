# coding: utf-8
module Roboparser
  class Loader
    def initialize
      @status=nil
      @meta=nil
      @html=nil
      @base_uri=nil
    end
    attr_reader :meta,:html,:status,:base_uri
    def visit(host,&pro)
      yiald true
      open(host.uri,'User-Agent'=>"Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20100101 Firefox/12.0 FirePHP/0.7.1")do |f|
        @status=f.status
        @html=f.read
        @meta=f.meta
        @base_uri=f.base_uri
      end
    rescue SocketError=>e
      puts e
    rescue OpenURI::HTTPError=>e
      puts e
    end
  end
end