module Robot

  class Parser
    def initialize
      @page=nil
      @dump_url=nil
      @dump_index=0
      @no_error=true
      @no_dump=true
      @count_error=0
      @MaxCountError=5
    end
    attr_reader :no_error
    attr_reader :no_dump
    attr_accessor :dump_index
    attr_accessor :dump_url
    attr_accessor :url
    attr_reader :page
    def save_to_error
      File.open('error.txt', 'a'){|file| file.write "error: dump_index=#{@dump_index} no download URL= #{@dump_url}\n"}
    end
    def goto(url)
      @dump_url=url
      while @count_error < @MaxCountError
        begin
          @page=Nokogiri::HTML(open(url,"User-Agent" => "Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20100101 Firefox/12.0 FirePHP/0.7.1").read.encode("UTF-8","Windows-1251"))
          @count_error=@MaxCountError
          @no_error=true
          rescue
            @no_error=false
            @count_error+=1
            self.save_to_error
         end
      end
      @count_error=0
      @no_error
    end

    def xpath_a(xpath)
      refs=[]
      @page.xpath(xpath).each do |a|
        link=Hash.new
        link[:href]=a['href']
        link[:content]= a.content
        link[:xpath]= a.path
        refs.push(link)
      end
      refs
    end
    def css_a (css)
      refs=[]
      unless @page.nil?
        @page.css(css+" a").each do |a|
        link=Hash.new
        link[:href]=a['href']
        link[:content]= a.content
        link[:xpath]= a.path
        refs.push(link)
        end
      end
      refs
    end
    def css_no_nil(li,css_in,attribute_in,node_number)
      css=li.css(css_in)
      unless css[node_number].nil?
        if attribute_in == "content"
          attribute=css[node_number].content
        else
          attribute=css[node_number][attribute_in]
        end
        unless attribute.nil?
          attribute.gsub(/$\n?|\r/," ")
        else
          ""
        end
      else
        ""
      end
    end

    def save_to_log
      File.open('log.txt', 'a'){|file| file.write "#{@dump_index}=#{@dump_url}\n"}
    end
    def save_to_dump
      File.open('dump.txt', 'w'){|file| file.write "#{@dump_index}\n#{@dump_url}\n"}
    end
    def read_from_dump
      unless File.zero?("dump.txt")
        dump=File.readlines("dump.txt")
        @dump_index=dump[-2].chomp.to_i
        @dump_url=dump[-1].chomp
        @no_dump=false
        File.open('dump.txt', 'w'){|file| file.write ""}
      else
        @no_dump=true
      end
    end
    def script_to_nodeset (script)
      html=script.gsub('\"','"')
      Nokogiri::HTML(html)
    end
  end


  class Setting
    def initialize(url,)
      @url=url
      @attribute_block_css=nil
      @attribute_param_css=[]

    end
  end

  class Loader
    def initialize(encoding=nil)
      @url=nil
      @html=nil
      @error_loader={}
      @encoding=encoding
      @encoding=Encoding.default_external unless verify_encoding?(encoding)
    end
    def go(url)
      @html=open(url,"User-Agent" => \
      "Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20100101 Firefox/12.0 FirePHP/0.7.1").read
      @error_loader[url]=nil
    rescue
      @html=""
      @error_loader[url]=url
      save_to_log(url)
    end
    def goto(url)
      error_count=0
      begin
        go(url)
        error_count+=1
      end until @error_loader[url].nil? || error_count==5
      if @html.encoding<>@encoding
         @html.encode!(@encoding,@html.encoding)
         @html.encoding=@encoding
      end
    end
    def verify_encoding?(encoding)
      # пока проверяем на nil? позже надо дописать include? в список известных руби кодировок
      if encoding.nil?
        true
      else
        false
      end
    end
    def save_to_log (error)
      File.open('log.txt', 'a'){|file| file.write "Страница #{error} не доступна."}
    end
  end

  class LoaderWatir < Loader
    def initialize(encoding=nil)
      @url=nil
      @html=nil
      client = Selenium::WebDriver::Remote::Http::Default.new
      client.timeout = 300
      @watirff = Watir::Browser.new :ff, :http_client => client
      @error_loader={}
      @encoding=encoding
      @encoding=Encoding.default_external unless verify_encoding?(encoding)
    end
    def go(url)
      @watirff.goto url
      @html=@watirff.html
      @error_loader[url]=nil
      @url
    rescue
      @html=""
      @error_loader[url]=url
      save_to_log(url)
    end
  end

  class NokoParser
    def initialize
      @type_element_out=nil  # page, block, variable, script
      @methods_parse=nil  #css, xparse
    end
    def xpath(xpath,type_out,)
      refs=[]
      @page.xpath(xpath).each do |a|
        link=Hash.new
        link[:href]=a['href']
        link[:content]= a.content
        link[:xpath]= a.path
        refs.push(link)
      end
      refs
    end
  end

  class Block
    def initialize(Setting)
      @size
      @count_variable
    end
  end

  class Page (url,page_encoding)
  def initialize
    @url=url
    @page_encoding
    @html=nil
    @loader=nil       # Watir, Open-Uri, file
  end
  end

  class Data
    def initialize
      @data={}
    end
    def add (name,record)
      @data[name]=record
    end
  end
  class Record
    def initialize
      @css=nil
      @index=nil
      @attribute=nil
    end
    attr_accessor :css
    attr_accessor :index
    attr_accessor :attribute
    def valid?
      unless @css.nil?||@index.nil?||@attribute.nil?
        true
      else
        false
      end
    end
  end
end
