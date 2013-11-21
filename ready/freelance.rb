# coding: utf-8
#hhttps://freelance.ru/

require_relative './lib/init'

module Robot
  #name,parse_method,key_parse,attribute,element_index=0
  path="./data/"
  file_output='baza.csv'
  url="https://freelance.ru/"
  key_word=['парсe','парси','ruby','сайт'].join('|')

  block_record=Record.new
  block_record.name='block'
  block_record.method='css'
  block_record.key=".proj"
  block_record.index=nil
  block_record.attribute=nil

  href_record=Record.new
  href_record.name='block'
  href_record.method='css'
  href_record.key="a.ptitle"
  href_record.index=0
  href_record.attribute='href'

  title_record=Record.new
  title_record.name='block'
  title_record.method='css'
  title_record.key="a.ptitle"
  title_record.index=0
  title_record.attribute='content'

  content_record=Record.new
  content_record.name='block'
  content_record.method='css'
  content_record.key="a.descr"
  content_record.index=0
  content_record.attribute='content'


  loader=Loader.new
  loader.goto(url)
  parser=NokoParser.new
  parser.document(loader.html)
  page=parser.page
  nodes_blocks=parser.nodes_by_record(page,block_record)
  nodes_blocks.each do |block|
    content=parser.attribute_by_record(block,content_record)
    title=parser.attribute_by_record(block,title_record)
    if (title+content)=~/#{key_word}/ui
      href=parser.attribute_by_record(block,href_record)
      href=loader.url_valid(href)
      send_to_mail(href,content)
    end
  end
end
