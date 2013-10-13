class ParserWatir < Parser
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


end