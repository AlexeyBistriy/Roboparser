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
  dset.add('href_shablon','css','h2 a','href')
  dset.add('tags','css','h2 a','href')
  dset.add('min_img','css','.b-post__price','content')
  dset.add('big_imj','css','.b-post__body','content')
  dset.add('description','css','.b-post__body','content')
  loader=Loader.new
  loader.goto(url)
  parser=NokoParser.new
  parser.document(loader.html)
  page=parser.page
  nodesblocks=parser.nodes_by_record(page,block_record)
  nodesblocks.each do |node|
    urls.push(parser.attribute_by_record(node,site_record))
  end
  next_href=parser.attribute_by_record(page,next_page)
  next_url=loader.url_valid(next_href)
  unless next_href==''
    loader.goto(next_url)
    parser=NokoParser.new
    parser.document(loader.html)
    page=parser.page

    next_href=parser.attribute_by_record(page,next_page)
    next_url=loader.url_valid(next_href)
  end

end

