# coding: utf-8
#"http://www.kbb.com/"

require_relative 'constants'
require_relative 'parser'

module Robot
  #name,parse_method,key_parse,attribute,element_index=0
  file_output='baza.cvs'
  url="http://www.kbb.com/car-pictures/"
  path="./data/"
  #key_word=["парсер","парсить","программист"].join("|")

  menu=Menu.new

  #Selector page Menu
  menu_record=Record.new
  menu_record.name='menu'
  menu_record.method='css'
  menu_record.key='p.description a'
  menu_record.index=nil
  menu_record.attribute=nil

  #menu_set=Data_set.new
  #menu_set.add('title','css','a','content')
  #menu_set.add('link','css','a','href')

  # selector next page
  next_page=Record.new
  next_page.name='Next'
  next_page.method='css'
  next_page.key='a.pager-next'
  next_page.index=0
  next_page.attribute='href'

  block_record=Record.new
  block_record.name='block'
  block_record.method='css'
  block_record.key='img.thumbImage'
  block_record.index=nil
  block_record.attribute=nil

  img=Record.new
  img.name='img'
  img.method='attribute'
  img.key=nil
  img.index=nil
  img.attribute='href'


  loader=Loader.new
  loader.goto(url)
  parser=NokoParser.new
  parser.document(loader.html)
    page=parser.page
    menu_nodes=parser.nodes_by_record(page,menu_record)
    menu.add(menu_nodes)
    menu.save_to_file(path,'model.csv')
    next_url=parser.attribute_by_record(page,next_page)
  #  while next_url
  #    loader.goto(next_url)
  #    parser.document(loader.html)
  #    page=parser.page
  #    menu_nodes=parser.nodes_by_record(page,menu_record)
  #    menu.add(menu_nodes)
  #    menu.save_to_file(path,'model.csv')
  #    next_url=parser.attribute_by_record(page,next_page)
  #  end
  #
  menu.tree.each do |item|

      loader.goto(item[:href])
      parser.document(loader.html)
      page=parser.page
      nodesblocks=parser.nodes_by_record(page,block_record)
      nodesblocks.each do |nodesblock|
        img_url=parser.attribute_by_record(nodesblock,d_set)
        img_url.gsub!(/96x72/,'640x480')
        uri=loader.uri.join(img_url)
        response_to_file(path,item[:content]+'/'+img,uri,nil)
      end
  end
end

