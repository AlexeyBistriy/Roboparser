# coding: utf-8
#https://www.weblancer.net/projects/

require_relative './lib/init'


module Robot
  #name,parse_method,key_parse,attribute,element_index=0
  path="./data/"
  file_output='baza.csv'
  url="https://www.weblancer.net/projects/"
  key_word=['парсe','парси','ruby','сайт'].join('|')

  block_record=Record.new
  block_record.name='block'
  block_record.method='css'
  block_record.key=".il_main"
  block_record.index=nil
  block_record.attribute=nil

  href_record=Record.new
  href_record.name='block'
  href_record.method='css'
  href_record.key="a.item"
  href_record.index=0
  href_record.attribute='href'

  content_record=Record.new
  content_record.name='block'
  content_record.method='css'
  content_record.key="a.item"
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
    puts "-------------------------------------"
    puts content
    if content=~/#{key_word}/ui
      href=parser.attribute_by_record(block,href_record)
      href=loader.url_valid(href)
      puts '++++++++++++++++++++++++++++++++++++++++++'
      puts href
      puts '++++++++++++++++++++++++++++++++++++++++++'
      send_to_mail(href,content)
    end
  end
end
