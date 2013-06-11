class ParserWatir
  def initialize
     client = Selenium::WebDriver::Remote::Http::Default.new
     client.timeout = 380
     @watirff = Watir::Browser.new :ff, :http_client => client
     @html=nil
     @page=nil
     @url=nil
  end
  attr_accessor :url
  attr_reader :page
  def goto(url)
    @watirff.goto url
    @url=@watirff.url
    @html=html=@watirff.html
    @page=Nokogiri::HTML(@html)
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
  def xpath_a(xpath)
    refs=[]
    page = Nokogiri::HTML(@html)
    page.xpath(xpath).each do |a|
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
    page = Nokogiri::HTML(@html)
    page.css(css+" a").each do |a|
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
  def dump

  end
  def to_dump

  end
  def to_html
  end
  def compare
  end
  def base_href
  end
  def no_base_href
  end
  def root_href
  end
  def next
  end
  def back
  end

end