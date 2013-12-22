# coding: utf-8
module Robot

  class Loader
    include MyFile
    def initialize(encoding='UTF-8')
      @uri=nil
      @html=nil
      @header=nil
      @encoding=encoding
    end
    attr_reader :uri,:html,:header
    def go(url_)
      @uri=Addressable::URI.parse(url_).normalize
      l=open(@uri,'User-Agent'=>"Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20100101 Firefox/12.0 FirePHP/0.7.1")
      @html=l.read
      @header=l.meta
      save_to_log(url_)
      true
    rescue
      @html=''
      error_to_log(url_)
      false
    end
    def goto(url)
      fail_trys=TRY_COUNT_LOAD.times do
        break if go(url)
      end
      #case @header['content-type']
      #  when /windows(:?-)?1251/i
      #    cp='Windows-1251'
      #  when /cp(:?-)?1251/i
      #    cp='Windows-1251'
      #  when /utf(:?-)?8/i
      #    cp='UTF-8'
      #  when  /koi8(:?-)?r/i
      #    cp='KOI8-R'
      #  when  /koi8(:?-)?u/i
      #    cp='KOI8-U'
      #  else
      #    if utf8?(@html)
      #      cp='UTF-8'
      #    else
      #      cp='Windows-1251'
      #    end
      #end
      if utf8?(@html)
        cp='UTF-8'
      else
        cp='Windows-1251'
      end

      @html.encode!(@encoding,cp,invalid: :replace,undef: :replace) if @html.respond_to?("encode!") and cp!=@encoding
      !fail_trys
    end
    def utf8?(string)
      string.unpack('U*') rescue return false
      true
    end
    def error_to_log (error)
      File.open('log.txt', 'a'){|file| file.write "Ресур #{error} не доступен.\n"}
    end
    def save_to_log (log_element)
      File.open('log.txt', 'a'){|file| file.write "Ресурс #{log_element} загружен.\n"}
    end
    def response_to_file (path_dir,name_file,url,encoding='UTF-8')
      file=file_name_valid(name_file)
      path=path_dir
      path+='/' unless path=~/\/$/
      uri=Addressable::URI.parse(url).normalize
      w= encoding.nil? ? 'wb' : 'w:'+encoding
      File.open(path+file, w) do |f|
        f.write(RestClient.get(uri.to_str))
      end
    rescue
      error_to_log(uri.to_str)
    end
    def url_valid (url)
      uri=Addressable::URI.parse(url).normalize
      @uri.join(uri.to_str)
    end
  end

  class LoaderWatir < Loader
    def initialize(encoding='UTF-8')
      @uri=nil
      @html=nil
      @header=nil
      client = Selenium::WebDriver::Remote::Http::Default.new
      client.timeout = 300
      @watirff = Watir::Browser.new :ff, :http_client => client
      @encoding=encoding

    end
    def go(url_)
      #url=Addressable::URI.parse(url_)
      #url=url.normalize
      @uri=Addressable::URI.parse(url_).normalize
      @watirff.goto url_
      @html=@watirff.html
      save_to_log(url_)
      true
    rescue
      @html=''
      error_to_log(url_)
      false
    end
    def goto(url)
      fail_trys=TRY_COUNT_LOAD.times do
        break if go(url)
      end
      if utf8?(@html)
        cp='UTF-8'
      else
        cp='Windows-1251'
      end

      #@html.encode!(@encoding,cp) if @html.respond_to?("encode!") and cp!=@encoding
      unless fail_trys
        true
      else
        false
      end
    end
  end
  class LoaderRest <Loader
    def initialize
      super
      @code=nil
      @cookies=nil
    end
    def go(url_)
      @uri=Addressable::URI.parse(url_).normalize
      rest=RestClient.get(@uri.to_str,'User-Agent'=>"Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20100101 Firefox/12.0 FirePHP/0.7.1")
      @html=rest.body
      @header=rest.headers
      @code=rest.code
      @cookies=rest.cookies
      save_to_log(url_)
      true
    rescue
      @html=''
      error_to_log(url_)
      false
    end

  end
end