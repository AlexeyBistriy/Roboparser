# coding: utf-8
module Roboparser
  class Host
    def initialize(options)
      @name=options[:name]
      @url=options[:url]
      @uri=Addressable::URI.parse(@url).normalize

    end
    attr_reader :name,:url,:uri
  end
end