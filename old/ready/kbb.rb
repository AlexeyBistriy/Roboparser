# coding: utf-8
#"http://www.kbb.com/"

require_relative './lib/init'

module Robot
  #name,parse_method,key_parse,attribute,element_index=0
  file_output='baza.cvs'
  url='http://www.kbb.com/car-pictures?p=4'
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
  block_record.key='.thumbImage'
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
  menu.add(menu_nodes,loader.uri)
  next_href=parser.attribute_by_record(page,next_page)
  next_url=loader.url_valid(next_href)
  while next_href!=''
    loader.goto(next_url)
    parser.document(loader.html)
    page=parser.page
    menu_nodes=parser.nodes_by_record(page,menu_record)
    menu.add(menu_nodes,loader.uri)
    next_href=parser.attribute_by_record(page,next_page)
    next_url=loader.url_valid(next_href)
  end
  menu.save_to_file(path,'model.csv')
  menu.tree.each do |item|
    loader.goto(item[:href])
    dirs=FileUtils.makedirs(path+item[:content].gsub(/[ ]+/,'/'))
    dir=dirs[0]
    links=loader.html.scan(/\"Url\":\"(http:\/\/file\.kelleybluebookimages\.com\/kbb\/\/[^"]*)"/)
    links.each_index do |index|
      loader.response_to_file(dir,index.to_s+'_'+links[index][0].gsub(/\s+|\.|\:|\?|\&/,'_')+'.jpg',links[index][0],nil)
    end

  end
end

