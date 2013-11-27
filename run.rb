# coding: utf-8
#Нужен отпарсить один из сайтов joomlaz.ru или joomla-master.org (текст и картинки) в записью в базу.
#   Для записи нужны следующие поля:
#      - тематика шаблона
#      - название шаблона
#      - превью шаблона
#      - большая картинка шаблона
#      - описание
#Язык скрипта значения не имеет, потому что нужен дамп mysql

require_relative './lib/init'

module Robot
  #name,parse_method,key_parse,attribute,element_index=0
  url='http://joomlaz.ru/shablony-joomla.html'
  path="./data/"

  next_page=Record.new
  next_page.name='Next'
  next_page.method='css'
  next_page.key='a[title="Вперёд"]'
  next_page.index=0
  next_page.attribute='href'

  block_record=Record.new
  block_record.name='block'
  block_record.method='css'
  block_record.key='.items-row'
  block_record.index=nil
  block_record.attribute=nil

  dset=Data_set.new
  dset.add('title_shablon','css','h2 a','content')
  dset.add('title','css','h2 a','content')
  dset.add('tags','css','.cp_tag a','content',nil)
  dset.add('description','xpath','//div[@class="item column-1"]/p[2]','content')
  dset.add('href_shablon','css','h2 a','href')
  dset.add('min_img','css','a.thumbnail img','src')
  dset.add('big_imj','css','a.thumbnail','href')


  loader=Loader.new
  parser=NokoParser.new

  loader2=Loader.new
  parser2=NokoParser.new

  attr2_record=Record.new
  attr2_record.name='full_description'
  attr2_record.method='xpath'
  attr2_record.key='//div[@class="item-page"]/p[2]/following-sibling::*[@style="text-align: justify;"]'
  attr2_record.index=nil
  attr2_record.attribute='content'


  loader.goto(url)
  parser.document(loader.html)
  page=parser.page
  nodesblocks=parser.nodes_by_record(page,block_record)
  nodesblocks.each do |node|
    record=[]
    dset.values=parser.attribute_by_data(node,dset)
    #dset - 0 # VARCHAR(255)
    record.push(dset.values[0].scan(/^\s*([^-]*)\s-\s/).join())
    #dset - 1 # VARCHAR(255)
    record.push(dset.values[1].scan(/^\s*[^-]*\s-\s(.*)/).join())
    #dset - 2 #VARCHAR(255)
    record.push(dset.values[2])
    #dset - 3 #TEXT
    record.push(dset.values[3])
    #dset - 4 #TEXT
    loader2.goto(loader.url_valid(dset.values[4]))
    parser2.document(loader2.html)
    page2=parser2.page
    record.push(parser2.attribute_by_record(page2,attr2_record))
    #dset - 5 # BLOB
    dset.values[5]=loader.url_valid(dset.values[5]).to_str
    img=RestClient.get(dset.values[5])
    fl=File.open('c:\temp\img001.jpg', 'rb')
    img2=fl.read.unpack('H*')

    puts img2.class
    puts img2[0].encoding
    puts img2
    fl.close
    #record.push(img.unpack('H*'))
    #dset - 6 MEDIUMBLOB
    dset.values[6]=loader.url_valid(dset.values[6]).to_str
    puts dset.values.join('|||')
  end
  #next_href=parser.attribute_by_record(page,next_page)
  #next_url=loader.url_valid(next_href)
  #unless next_href==''
  #  loader.goto(next_url)
  #  parser=NokoParser.new
  #  parser.document(loader.html)
  #  page=parser.page
  #
  #  next_href=parser.attribute_by_record(page,next_page)
  #  next_url=loader.url_valid(next_href)
  #end

end