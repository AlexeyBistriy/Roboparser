# coding: utf-8
module Robot
  class Loader
    def initialize(encoding='UTF-8')
      @url=nil
      @html=nil
      @load=nil
      @encoding=encoding
      @encoding='UTF-8' unless verify_encoding?(encoding)
    end
    attr_reader :html
    def go(url)
      @html=open(url,'User-Agent'=>"Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20100101 Firefox/12.0 FirePHP/0.7.1").read
      true
    rescue
      @html=''
      save_to_log(url)
      false
    end
    def goto(url)
      error_count=0
      @load=false
      until @load || error_count==5
        @load=go(url)
        error_count+=1
      end
      @html.encode!(@encoding,@html.encoding) unless @html.encoding==@encoding
      @load
    end
    def verify_encoding?(encoding)
      #TODO пока проверяем на nil? позже надо дописать include? в список известных руби кодировок
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
      true
    rescue
      @html=''
      save_to_log(url)
      false
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
    def document(html)
      @page=Nokogiri::HTML(html)
    end
    def parse_html(html)
      Nokogiri::HTML(html)
    end
    def cut_blocks(document,record)
      case record.method
        when 'css'
          document.css(record.key)
        when 'xpath'
          document.xpath(record.key)
      end
    end

    def parse_by_record(doc_or_node,record)
      case record.method
        when 'css'
          doc_or_node.css(record.key)
        when 'xpath'
          doc_or_node.xpath(record.key)
      end
    end
    def by_record(node2,record)
      case record.method
        when 'css'
          nodeset2=node2.css(record.key)
        when 'xpath'
          nodeset2=node2.xpath(record.key)
      end
      unless attribute?(nodeset2,record.attribute,record.index)
        attribute(nodeset2,record.attribute,record.index)
      else
        ''
      end
    end
    def by_data(block,dataset)
       dataset.records.map do|record|
         by_record(block,record)
       end
    end
    def attribute(node3,attribute='content',index=0)
      if attribute=='content'
        node3[index].content
      else
        node3[index][attribute.to_sym]
      end
    end
    def attribute?(node4,attribute='content',index=0)
      if attribute=='content'

        puts "============="
        p node4.inspect
        puts node4.nil?
        puts node4.empty?
        puts node4[index].nil?
        puts node4[index].content.nil?
        node4.nil?||node4.empty?||node4[index].nil?||node4[index].content.nil?
      else
        node4.nil?||node4.empty?||node4[index].nil?||node4[index][attribute.to_sym].nil?
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
    def add(nodeset_a)
       nodeset_a.each do |element|
         @tree.push([:content=>element.content,:href=>element[:href]]) if element.content&&element[:href]
       end
    end
    def save_to_file (file_output,encoding='UTF-8')
      CSV.open(file_output, 'a:'+encoding)do |line|
        do
          line << @tree
        end
    end
  end

  class Data_set
    def initialize
      @records=[]
      @values=[]
    end
    attr_reader :records
    attr_accessor :values
    def add (name,parse_method,key_parse,attribute,element_index=0)
      new_record=Record.new
      new_record.name=name
      new_record.method=parse_method
      new_record.key=key_parse
      new_record.attribute=attribute
      new_record.index=element_index
      if new_record.valid?
        @records.push(new_record)
        @values.push('')
      end
    end
    def head_save_to_file(path,name_file,encoding='UTF-8')
      file=name_file.gsub(/\&|\/|\\|\<|\>|\||\*|\?|\"/," ")
      CSV.open( path+file, 'a:'+encoding)do |line|
         line << @records.map{|record| record.name}
      end
    end
    def save_to_file (pats,name_file,encoding='UTF-8')
      file=name_file.gsub(/\&|\/|\\|\<|\>|\||\*|\?|\"/," ")
      CSV.open(path+file, 'a:'+encoding)do |line|
         line << @values
      end
      #File.open(file_output, append){|file| file.write @data.map{|record| record.value}.join(" ")+"\n"}
    end
    def data_puts
      puts @values.join(' ')+"\n"
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
    end
    attr_accessor :name
    attr_accessor :method
    attr_accessor :key
    attr_accessor :attribute
    attr_accessor :index
    def valid?
      unless @name.nil?||@method.nil?||key.nil?||@attribute.nil?||@index.nil?
        true
      else
        false
      end
    end
  end
end
