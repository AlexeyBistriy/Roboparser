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
      @html=open(url,"User-Agent"=>"Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20100101 Firefox/12.0 FirePHP/0.7.1").read
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
      @page=nil
      #@type_element_out=nil  # page, block, variable, script
      #@methods_parse=nil  #css, xparse
    end
    def xpath(node,key)
       node.xpath(key)
    end
    def css(node,key)
       node.css(key)
    end
    def parse_page(html)
      @page=Nokogiri::HTML(html)
    end
    def parse_html(html)
      Nokogiri::HTML(html)
    end
    def blocks(node,record)
      case record.method
        when "css"
          nodeset=node.css(record.key)
        when "xpath"
          nodeset=node.xpath(record.key)
      end
    end
    def by_record(node,record)
       case record.method
        when "css"
          nodeset=node.css(record.key)
        when "xpath"
          nodeset=node.xpath(record.key)
       end
       if index?(nodeset,record.index)&& attr?(nodeset[record.index],record.attribute)
         attr(nodeset[index],record.attribute)
       else
       ""
       end
    end
    def by_data(block,data)
       data=data
       data.each!{|record| record.value=by_record(block,record)}
       data
    end
    def attr(node,attribute)
      if attribute=="content"
        node.content
      else
        node[attribute.to_s]
      end
    end
    def attr?(node,attribute)
      if attribute=="content"
        node.content.nil?
      else
        node[attribute.to_s].nil?
      end
    end
    def index?(node,index)
       node.[index].nil?
    end
    def by_data

    end
    def regex(node,attribute,regex)
      node.find_all{|element| element[attribute]=~/#{regex}/}
    end
    def no_script(html)
      html.gsub('\"','"')
    end
  end

  class Block
    def initialize(node)
      @node=node
    end
    def script_to_nodeset (script)
      html=script.gsub('\"','"')
      Nokogiri::HTML(html)
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
    def add (name,parse_method,key_parse,attribute,element_index=0)
      new_record=Record.new
      new_record.name=name
      new_record.method=parse_method
      new_record.key=key_parse
      new_record.attribute=attribute
      new_record.index=element_index
      @data[new_record.name]=new_record if new_record.valid?
    end
  end
  class Record
    def initialize
      @name=nil
      @method=nil
      @key=nil
      @index=nil
      @attribute=nil
      @value=""
    end
    attr_accessor :name
    attr_accessor :method
    attr_accessor :key
    attr_accessor :attribute
    attr_accessor :index
    attr_accessor :value
    def valid?
      unless @name.nil?||@method.nil?||key.nil?||@attribute.nil?||||@index.nil?
        true
      else
        false
      end
    end
  end
end
