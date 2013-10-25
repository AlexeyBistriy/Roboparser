# coding: utf-8
module Robot
  class Loader
    def initialize(encoding='UTF-8')
      @url=nil
      @html=nil
      @error_loader={}
      @encoding=encoding
      @encoding='UTF-8' unless verify_encoding?(encoding)
    end
    attr_reader :html
    def go(url)
      @html=open(url,'User-Agent'=>"Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20100101 Firefox/12.0 FirePHP/0.7.1").read
      @error_loader[url]=nil
    rescue
      @html=''
      @error_loader[url]=url
      save_to_log(url)
    end
    def goto(url)
      error_count=0
      @error_loader[url]='загрузка'
      begin
        go(url)
        error_count+=1
      end until @error_loader[url].nil? || error_count==5
      if @html.encoding!=@encoding
         @html.encode!(@encoding,@html.encoding)
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
      @html=''
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
    attr_reader :page
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
    def cut_blocks(node,record)
      case record.method
        when 'css'
          nodeset=node.css(record.key)
        when 'xpath'
          nodeset=node.xpath(record.key)
      end
    end
    def by_record(node,record)
      case record.method
        when 'css'
          nodeset=node.css(record.key)
        when 'xpath'
          nodeset=node.xpath(record.key)
      end
      unless attribute?(nodeset,record.attribute,record.index)
        attribute(nodeset,record.attribute,record.index)
      else
        ''
      end
    end
    def by_data(block,data)
       data.each do|record|
         record.value=by_record(block,record)
       end
    end
    def attribute(node,attribute='content',index=0)
      if attribute=='content'
        node[index].content
      else
        node[index][attribute.to_sym]
      end
    end
    def attribute?(node,attribute='content',index=0)
      if attribute=='content'
       node.nil?||node.empty?||node[index].nil?||node[index].content.nil?
      else
        node.nil?||node.empty?||node[index].nil?||node[index][attribute.to_sym].nil?
      end
    end
    def regex(node,attribute,regex)
      node.find_all{|element| element[attribute]=~/#{regex}/}
    end
    def no_script(node)
      script=node.to_s
      tt=script.gsub /<script[^>]*>\s*document.write\(\'(?<sc>[^']+)\'\);<\/script>/u, '\k<sc>'
      html=tt.gsub('\"','"')
      Nokogiri::HTML(html)
    end
  end

  class Menu
    def initialize
      @tree=[]
    end
    attr_reader :tree
    def add(href,title='baza')
       @tree.push({:href=>href,:title=>title})
    end
  end

  class Data_set
    def initialize
      @data=[]
    end
    attr_accessor :data
    def add (name,parse_method,key_parse,attribute,element_index=0)
      new_record=Record.new
      new_record.name=name
      new_record.method=parse_method
      new_record.key=key_parse
      new_record.attribute=attribute
      new_record.index=element_index
      @data.push(new_record) if new_record.valid?
    end
    def save_to_file (file_output,encoding='UTF-8')
      CSV.open(file_output, 'a:'+encoding)do |line|
         line << @data.map{|record| record.value}
      end
      #File.open(file_output, append){|file| file.write @data.map{|record| record.value}.join(" ")+"\n"}
    end
    def data_puts
      puts @data.map{|record| record.value}.join(' ')+"\n"
    end
    def send_to_mail(theme,body,email_to='alexeybistriy@gmail.com',email_from='newsvin@ukr.net')
        message=""
        message<<"From: My Rorbo <#{email_from}>\n"
        message<<"To: Alexey Bistriy <#{email_to}>\n"
        message<<"Subject: #{theme}\n"
        message<<body
        smtp=Net::SMTP.new('smtp.ukr.net',465)
        smtp.enable_tls
        smtp.start('localhost','newsvin@ukr.net','VVVVV',:plain) do |smtp|
          smtp.send_message message, from, to
        end
    end
  end
  class Record
    def initialize
      @name=nil
      @method=nil
      @key=nil
      @index=nil
      @attribute=nil
      @value=''
    end
    attr_accessor :name
    attr_accessor :method
    attr_accessor :key
    attr_accessor :attribute
    attr_accessor :index
    attr_accessor :value

    def valid?
      unless @name.nil?||@method.nil?||key.nil?||@attribute.nil?||@index.nil?
        true
      else
        false
      end
    end
  end
end
