class TreeRefs
  def initialize
    @parse=Parser.new
  end


  def root

  end
  def add_brenches
  end
  def cut_brences

  end
  def view_links(html)
    parser_refs=@parse.nokogiri_hrefs(html,0)
    parser_refs.each do |link|
      puts ""
      puts "+++++++++++++++++++++++++++++++++"
      puts link[:href]
      puts link[:content] #parser_as
      puts link[:level]
      link[:keys].each do |key|
        puts key
        puts link[:attributes][key]
      end
      puts link[:xpath]
    end
  end
  def view_navigate(html,xpath)
    #/html/body/div[1]/div[3]/div[1]/div[1]/div/div[1]/div[1]/div/dl/dd/dl/dd/a
    parser_refs=@parse.navigate_xpath(html,xpath)
    parser_refs.each do |link|
      puts ""
      puts "+++++++++++++++++++++++++++++++++"
      puts link[:href]
      puts link[:content] #parser_as
      link[:keys].each do |key|
        puts key
        puts link[:attributes][key]
      end
      puts link[:xpath]
    end
  end
end