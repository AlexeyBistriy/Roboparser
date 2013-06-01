class Page

def initialize(html)
  refs=[]
  @page = Nokogiri::HTML(html)
end

end