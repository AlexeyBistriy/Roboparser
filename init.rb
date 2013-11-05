# coding: utf-8
#"https://www.fl.ru/"


require_relative 'constants'
require_relative 'parser'


module Robot
  #name,parse_method,key_parse,attribute,element_index=0
  path="./data/"
  file_output='baza.csv'
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

  title_record=Record.new
  title_record.name='href'
  title_record.method='css'
  title_record.key='title'
  title_record.index=0
  title_record.attribute='content'

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
    if href=='http://www.23crew.info/'
    puts loader.go(href)
    parser.document(loader.html)
    page=parser.page
    puts page.to_s
    puts '-----------------------------'
    puts page.meta_encoding
    puts page.title
    puts '------------------------------'
    title=parser.attribute_by_record(page,title_record)
    puts href
    puts title
    puts '++++++++++++++++++++++++++'
    titles.push(title)
    end
  end












  #key_word=['парсер','парсить','программист'].join('|')
  #block_record=Record.new
  #block_record.name='block'
  #block_record.method='css'
  #block_record.key="div#projects-list div"
  #block_record.index=nil
  #block_record.attribute=nil
  #dset=Data_set.new
  #dset.add('title','css','.b-post__title a','content')
  #dset.add('link','css','.b-post__title a','href')
  #dset.add('price','css','.b-post__price','content')
  #dset.add('task','css','.b-post__body','content')
  #dset.data_puts
  #loader=Loader.new
  #loader.goto(url)
  #parser=NokoParser.new
  #parser.document(loader.html)
  #page=parser.page
  #nodes_blocks=parser.nodes_by_record(page,block_record)
  #nodes_blokck_array=parser.regex(nodes_blocks,'id',/project-item\d+/)
  #nodes_blokck_array.each do |block|
  #  dset.values=parser.attribute_by_data(parser.no_script(block),dset)
  #  #dset.save_to_file(path,file_output)
  #  if (dset.values[0]+dset.values[3])=~/#{key_word}/ui
  #    dset.send_to_mail(dset.values[1],dset.values[0]+dset.values[3])
  #  end
  #end
end
