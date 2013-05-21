class Parser
  def watir_links (watir)
    links=[]
    watir.as.each{|a| links.push(a.html)}
    links
  end
  def reg_links(html)
    html.scan(/<a\b(?:(?:"[^"]*"|'[^']*'|[^'">])*)>(?:.*?)<\/a>/)
  end
  def nokogiri_links(html)
    links=[]
    page = Nokogiri::HTML(html)
    page.css("a").each{|node| links.push(node.to_s)}
    links
  end
  def kind_href(href,base,hrefs)
    if href.scan(base).empty?
      "banner"
    elsif hrefs.include?(href)
      "navigate"
    else
      "new"
    end

  end
  def nokogiri_hrefs(html,level)
    refs=[]
    page = Nokogiri::HTML(html)
    page.css("a").each do |a|
      link=Hash.new
      link['href']=a['href']
      link['content']= a.content
      link['level']=level
      refs.push(link)
    end
    refs
  end
  def reg_hrefs(html,level)
    refs=[]
    html.scan(/<a\b(?:(?:"[^"]*"|'[^']*'|[^'">])*)>(?:.*?)<\/a>/).each do |refer|
    link=Hash.new
    /href\s*=\s*(?:["'](?<hrf>[^"']*)["']|(?<hrf>\S+))/.match(refer)
    link["href"]=Regexp.last_match(:hrf)
    /<a\b(?:(?:"[^"]*"|'[^']*'|[^'">])*)>(?<cnt>.*?)<\/a>/.match(refer)
    link["content"]= Regexp.last_match(:cnt)
    link["level"]=level
    refs.push(link)
    end
  refs
  end
  def reg_href(link)
    /href\s*=\s*(?:["'](?<hrf>[^"']*)["']|(?<hrf>\S+))/.match(link)
    Regexp.last_match(:hrf)
  end
  def watri_divs(watir)
    divs=[]
    watir.divs.each{|div| divs.push(div.html)}
    divs
  end
  def watir_imgs(watir)
    imgs=[]
    watir.imgs.each{|img| imgs.push(img.html)}
    imgs
  end
  def variables

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