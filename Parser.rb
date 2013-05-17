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
  def nokogiri_links(watir)
    links=[]
    html=watir.html
    page = Nokogiri::HTML(html)
    page.css("a").each{|a| a.display}
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