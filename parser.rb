# coding: utf-8
module Robot
  module MyFile
    def file_name_valid name_file, os='Windows'
      if os=='Windows'
        name=name_file.gsub(/\&|\/|\\|\<|\>|\||\*|\?|\"|\n|\r/u,' ').strip
      end
    end
  end
  class Loader
    include MyFile
    def initialize(encoding='UTF-8')
      @uri=nil
      @html=nil
      @header=nil
      @encoding=encoding
    end
    attr_reader :html
    def go(url_)
      @uri=Addressable::URI.parse(url_).normalize
      l=open(@uri,'User-Agent'=>"Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20100101 Firefox/12.0 FirePHP/0.7.1")
      @html=l.read
      @header=l.meta
      true
    rescue
      @html=''
      save_to_log(url)
      false
    end
    def goto(url)
      fail_trys=TRY_COUNT_LOAD.times do
        break if go(url)
      end
      case @header['content-type']
        when /windows(:?-)?1251/i
          cp='Windows-1251'
        when /cp(:?-)?1251/i
          cp='Windows-1251'
        when /utf(:?-)?8/i
          cp='UTF-8'
        when  /koi8(:?-)?r/i
          cp='KOI8-R'
        when  /koi8(:?-)?u/i
          cp='KOI8-U'
        else
          if utf8?(@html)
            cp='UTF-8'
          else
            cp='Windows-1251'
          end
      end
      @html.encode!(@encoding,cp) if @html.respond_to?("encode!") and cp!=@encoding
      !fail_trys
    end
    def utf8?(string)
      string.unpack('U*') rescue return false
      true
    end
    def save_to_log (error)
      File.open('log.txt', 'a'){|file| file.write "Страница #{error} не доступна."}
    end
    def response_to_file (path,name_file,url,encoding='UTF-8')
      file=file_name_valid(name_file)
      w= encoding.nil? ? 'w' : 'w:'+encoding
      File.open(path+file, w) do |f|
        f.write(RestClient.get(url))
      end
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
      true
    rescue
      @html=''
      save_to_log(url)
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

      @html.encode!(@encoding,cp) if @html.respond_to?("encode!") and cp!=@encoding
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
    def nodes_by_record(doc_or_node,record)
      case record.method
        when 'css'
          doc_or_node.css(record.key)
        when 'xpath'
          doc_or_node.xpath(record.key)
      end
    end
    def attribute_by_record(doc_or_node,record)
      #puts '_______________________________'
      #puts doc_or_node.inspect
      #puts '_____________________________________'
      case record.method
        when 'css'
          nodeset=doc_or_node.css(record.key)
          unless attribute?(nodeset,record)
            attribute(nodeset,record)
          else
            ''
          end
        when 'xpath'
          nodeset=doc_or_node.xpath(record.key)
          unless attribute?(nodeset,record)
            attribute(nodeset,record)
          else
            ''
          end
        when "attribute"
          unless doc_or_node[record.attribute].nil?
            doc_or_node[record.attribute]
          end
      end

    end
    def attribute_by_data(doc_or_node,dataset)
       dataset.records.map do|record|
         attribute_by_record(doc_or_node,record)
       end
    end
    def attribute(nodeset,record)
      if record.attribute=='content'
        nodeset[record.index].content
      else
        nodeset[record.index][record.attribute.to_sym]
      end
    end
    def attribute?(nodeset,record)
      if record.attribute=='content'
        nodeset.nil?||nodeset.empty?||nodeset[record.index].nil?||nodeset[record.index].content.nil?
      else
        nodeset.nil?||nodeset.empty?||nodeset[record.index].nil?||nodeset[record.index][record.attribute.to_sym].nil?
      end
    end
    def regex(nodeset,attribute,regex)
      nodeset.find_all{|element| element[attribute]=~/#{regex}/}
    end
    def no_script(node)
      script=node.to_s
      tt=script.gsub /<script[^>]*>\s*document.write\(\'(?<sc>[^']+)\'\);<\/script>/u, '\k<sc>'
      html=tt.gsub('\"','"')
      Nokogiri::HTML(html)
    end
    def redirect?(title_regexp)
      text_title=page.css('title').text
      if text_title =~ /#{title_regexp}/
        true
      else
        false
      end
    end
  end

  class Menu
    include MyFile
    def initialize
      @tree=[]
    end
    attr_reader :tree
    def add(nodeset_a,regexp='')
      nodeset_a.each do |element|
         p element.inspect
         if element.content&&element[:href]&&!element[:href].empty?&& url?(element[:href],regexp)
          @tree.push({:content=>element.content,:href=>element[:href]})
         end
       end
    end
    def url?(url,regexp)
     if url=~/#{regexp}/
       true
     else
       false
     end
    end
    def save_to_file (path,file_output,encoding='UTF-8')
      file=file_name_valid(file_output)
      CSV.open(path+file, 'a:'+encoding)do |line|
        @tree.map do |item|
        line << [item[:content].sub(/\r|\n|/,' ').strip,item[:href]]
        end
      end
    end
  end

  class Data_set
    include MyFile
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
      file=file_name_valid(name_file)
      CSV.open( path+file, 'a:'+encoding)do |line|
         line << @records.map{|record| record.name}
      end
    end
    def save_to_file (path,name_file,encoding='UTF-8')
      file=file_name_valid(name_file)
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
        #smtp.start('localhost','newsvin@ukr.net','VVVVV',:plain) do |smtp|
        #  smtp.send_message message, from, to
        #end
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
    attr_accessor :name, :method, :key, :attribute, :index
    def valid?
      !(@name.nil?||@method.nil?||key.nil?||@attribute.nil?||@index.nil?)
    end
  end

end
