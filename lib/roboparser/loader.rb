module Roboparser
  class Loader
    def initialize

    end
    def visit(host)

    end
  end
class Host
  def initialize(options)
    @name=options[:name]
    @url=options[:url]
  end
  attr_reader :name, :url
end
end