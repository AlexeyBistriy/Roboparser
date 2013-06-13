class Parser
  def initialize
    @page=nil
    @url=nil
    @dump_index=0
    @no_error=true
    @no_dump=true
  end
  attr_reader :no_error
  attr_reader :no_dump
  attr_accessor :dump_index
  attr_accessor :dump_url
  attr_accessor :url
  attr_reader :page
  def goto(url)
      @no_error=true
      @dump_url=url
      @page=Nokogiri::HTML(open(url))
    rescue
      self.log
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
  def log
    @no_error=false
    File.open('error.txt', 'a'){|file| file.write "error: dump_index=#{@dump_index} no download URL= #{@dump_url}\n"}
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
      puts "unless"
      File.open('dump.txt', 'w'){|file| file.write ""}
    else
      puts "else"
      @no_dump=true
    end
  end

end