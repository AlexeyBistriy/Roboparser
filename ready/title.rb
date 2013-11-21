# coding: utf-8

require_relative './lib/init'


module Robot
  #name,parse_method,key_parse,attribute,element_index=0
  path="./data/"
  file_output='test.csv'
  url='https://www.fl.ru/projects/1726614/sparsit-title-ukazannyih-saytov.html'
  urls=[]
  titles=[]

  block_record=Record.new
  block_record.name='block'
  block_record.method='css'
  block_record.key=".prj_text a"
  block_record.index=nil
  block_record.attribute=nil

  site_record=Record.new
  site_record.name='href'
  site_record.method='attribute'
  site_record.key=nil
  site_record.index=nil
  site_record.attribute="title"

  #title_record=Record.new
  #title_record.name='href'
  #title_record.method='css'
  #title_record.key='title'
  #title_record.index=0
  #title_record.attribute='content'

  loader=Loader.new
  loader.goto(url)
  parser=NokoParser.new
  parser.document(loader.html)
  page=parser.page
  nodesblocks=parser.nodes_by_record(page,block_record)
  nodesblocks.each do |node|
    urls.push(parser.attribute_by_record(node,site_record))
  end

  urls.each do  |href|

    loader.goto(href)
    parser.document(loader.html)
    page=parser.page
    title=page.title
    titles.push([href,title])

  end

  titles.each do |item|
    CSV.open(path+file_output, 'a:UTF-8', {:col_sep=>";"})do |line|
      line << item
    end
  end

end
