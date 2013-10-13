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
        @page=Nokogiri::HTML(open(url))
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
  def css_no_nil(li,css_in,attribute_in)
    css=li.css(css_in)
    unless css[0].nil?
      if attribute_in == "content"
        attribute=css[0].content
      else
        attribute=css[0][attribute_in]
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
  def to_sms (sms)
    sms
  end
end