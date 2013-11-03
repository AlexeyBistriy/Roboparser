class Musor
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
class ParserWatir < Musor
  def initialize
    client = Selenium::WebDriver::Remote::Http::Default.new
    client.timeout = 300
    @watirff = Watir::Browser.new :ff, :http_client => client
    @html=nil
    @page=nil
    @url=nil
    @dump=0
  end
  def goto(url)
    @watirff.goto url
    @url=@watirff.url
    @html=@watirff.html
    @page=Nokogiri::HTML(@html)
  rescue Timeout::Error
    @url=url
    self.save_to_dump
  end
  def go
    self.goto(@url)
  end
  def watir_links
    links=[]
    @watirff.as.each{|a| links.push(a.html)} if @watirff
    links
  end
  def reg_links
    @html.scan(/<a\b(?:(?:"[^"]*"|'[^']*'|[^'">])*)>(?:.*?)<\/a>/) if @html
  end
  def nokogiri_links
    links=[]
    page = Nokogiri::HTML(@html)
    page.css("a").each{|node| links.push(node.to_s)}
    links
  end
  def nokogiri_hrefs
    refs=[]
    page = Nokogiri::HTML(@html)
    page.css("a").each do |a|
      link=Hash.new
      link[:href]=a['href']
      link[:content]= a.content
      link[:xpath]= a.path
      link[:attributes]=a.attributes
      link[:keys]=a.keys
      link[:valies]=a.values
      refs.push(link)
    end
    refs
  end
  def reg_hrefs
    refs=[]
    @html.scan(/<a\b(?:(?:"[^"]*"|'[^']*'|[^'">])*)>(?:.*?)<\/a>/).each do |refer|
      link=Hash.new
      /href\s*=\s*(?:["'](?<hrf>[^"']*)["']|(?<hrf>\S+))/.match(refer)
      link["href"]=Regexp.last_match(:hrf)
      /<a\b(?:(?:"[^"]*"|'[^']*'|[^'">])*)>(?<cnt>.*?)<\/a>/.match(refer)
      link[:content]= Regexp.last_match(:cnt)
      refs.push(link)
    end
    refs
  end
  def reg_href(link)
    /href\s*=\s*(?:["'](?<hrf>[^"']*)["']|(?<hrf>\S+))/.match(link)
    Regexp.last_match(:hrf)
  end
  def watri_divs
    divs=[]
    @watirff.divs.each{|div| divs.push(div.html)}
    divs
  end
  def watir_imgs
    imgs=[]
    @watirff.imgs.each{|img| imgs.push(img.html)}
    imgs
  end
  def simple1
    #hrefs = row.css("td a").map{ |a|
    #  a['href'] if a['href'].match("/wiki/")
    #}.compact.uniq
  end

end