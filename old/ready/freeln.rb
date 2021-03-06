# coding: utf-8
#"https://www.fl.ru/"

require_relative './lib/init'


module Robot
  #name,parse_method,key_parse,attribute,element_index=0
  path="./data/"
  file_output='baza.csv'
  url="https://www.fl.ru/?page=2&kind=5"
  key_word=['парсе','парси','ruby'].join('|')
  block_record=Record.new
  block_record.name='block'
  block_record.method='css'
  block_record.key="div#projects-list div"
  block_record.index=nil
  block_record.attribute=nil
  dset=Data_set.new
  dset.add('title','css','.b-post__title a','content')
  dset.add('link','css','.b-post__title a','href')
  dset.add('price','css','.b-post__price','content')
  dset.add('task','css','.b-post__body','content')
  #dset.data_puts
  loader=Loader.new
  loader.goto(url)
  parser=NokoParser.new
  parser.document(loader.html)
  page=parser.page
  nodes_blocks=parser.nodes_by_record(page,block_record)
  nodes_blokck_array=parser.regex(nodes_blocks,'id',/project-item\d+/)
  nodes_blokck_array.each do |block|
    dset.values=parser.attribute_by_data(parser.no_script(block),dset)
    #dset.save_to_file(path,file_output)
    if (dset.values[0]+dset.values[3])=~/#{key_word}/ui
      href=loader.url_valid(dset.values[1])
      send_to_mail(href,dset.values[0]+dset.values[3])
    end
  end
end
