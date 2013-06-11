class Parser
  def initialize
    @page=nil
    @url=nil
    @dump=0
  end
  attr_accessor :dump
  attr_accessor :url
  attr_reader :page
  def goto(url)
    @url=url
    @page=Nokogiri::HTML(open(url))
  rescue
    self.save_to_dump
  end
  def go
    self.goto(@url)
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
    @page.css(css+" a").each do |a|
      link=Hash.new
      link[:href]=a['href']
      link[:content]= a.content
      link[:xpath]= a.path
      refs.push(link)
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
        attribute.gsub(/$\n?/," ")
      else
        ""
      end
    else
      ""
    end
  end
  def save_to_dump
    File.open('error.txt', 'a'){|file| file.write "error: no download URL= #{@url}"}
    File.open('dump.txt', 'w'){|file| file.write "#{@dump}\n#{@url}\n#"}
  end
  def read_from_dump
    dump=File.readlines("dump.txt")
    unless dump.empty?
      @dump=dump[0].chomp.to_i
      @url=dump[1].chomp
    end
  end

end