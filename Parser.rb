class Parser
  def watir_links (watir)
    links=[]
    watir.as.each{|a| links.push(a.html)}
    links
  end
  def reg_links(watir)
    html=watir.html
    html.scan(/<a\b(?:(?:"[^"]*"|'[^']*'|[^'">])*)>(?:.*?)<\/a>/)
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
    page = Nokogiri::HTML(html)
    @nokogiri_hrefs=[]
    page.css("a").each do |a|
      link=Hash.new
      link['href']=a['href']
      link['text']= a.text
      link['content']= a.content
      link['level']=level
      @nokogiri_hrefs.push(link)
    end
    @nokogiri_hrefs
  end
  def reg_href(link)
    /href\s*=\s*(?:["'](?<hrf>[^"']*)["']|(?<hrf>\S+))/.match(link)
    Regexp.last_match(:hrf)
  end
  def reg_hrefs(html)
    @reg_hrefs=[]
    html.scan(/<a\b(?:(?:"[^"]*"|'[^']*'|[^'">])*)>(?:.*?)<\/a>/).each do |reg|
    link=Hash.new
    /href\s*=\s*(?:["'](?<hrf>[^"']*)["']|(?<hrf>\S+))/.match(reg)
    link["href"]=Regexp.last_match(:hrf)

    @reg_hrefs.push(link)

    end
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