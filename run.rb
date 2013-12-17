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
  url='http://www.treko.ru/strana/com#1'
  path="./data/"
  file='table.csv'
  #database='joomlaz'
  #table='result'
  index_file=0

  starturi=Addressable::URI.parse('http://www.treko.ru/').normalize

  block_record=Record.new
  block_record.name='block'
  block_record.method='xpath'
  block_record.key='.//table[@class="base"]/tr/td[1]'
  block_record.index=nil
  block_record.attribute=nil

  href_record=Record.new
  href_record.name='gorod_href'
  href_record.method='css'
  href_record.key='a'
  href_record.index=nil
  href_record.attribute='href'

  gorod_record=Record.new
  gorod_record.name='gorod_name'
  gorod_record.method='css'
  gorod_record.key='a'
  gorod_record.index=nil
  gorod_record.attribute='content'

  block_record2=Record.new
  block_record2.name='block2'
  block_record2.method='css'
  block_record2.key='p[style="margin: 4px"] a'
  block_record2.index=nil
  block_record2.attribute=nil

  href_record2=Record.new
  href_record2.name='page'
  href_record2.method='attribute'
  href_record2.key=nil
  href_record2.index=nil
  href_record2.attribute='href'

  block_record3=Record.new
  block_record3.name='block2'
  block_record3.method='xpath'
  block_record3.key='.//table[@class="base"]/tr'
  block_record3.index=nil
  block_record3.attribute=nil

  firma_record=Record.new
  firma_record.name='firma_name'
  firma_record.method='xpath'
  firma_record.key='./td[1]/div'
  firma_record.index=nil
  firma_record.attribute='content'

  email_record=Record.new
  email_record.name='email'
  email_record.method='xpath'
  email_record.key='./td[7]div/a'
  email_record.index=nil
  email_record.attribute='href'

  email_record=Record.new
  email_record.name='email'
  email_record.method='xpath'
  email_record.key='./td[7]/div/a'
  email_record.index=nil
  email_record.attribute='href'

  href_record3=Record.new
  href_record3.name='www'
  href_record3.method='xpath'
  href_record3.key='./td[8]/div/a'
  href_record3.index=nil
  href_record3.attribute='href'


  loader=Loader.new  'Windows-1251'
  parser=NokoParser.new

  loader2=Loader.new 'Windows-1251'
  parser2=NokoParser.new

  loader3=Loader.new 'Windows-1251'
  parser3=NokoParser.new

  loader4=Loader.new 'Windows-1251'
  parser4=NokoParser.new


  attr2_record=Record.new
  attr2_record.name='full_description'
  attr2_record.method='xpath'
  attr2_record.key='//div[@class="item-page"]/p[2]/following-sibling::*[@style="text-align: justify;"]'
  attr2_record.index=nil
  attr2_record.attribute='content'



  loader.goto(url)
  parser.document(loader.html)
  page=parser.page

  #эту часть зациклить

  nodesblocks=parser.nodes_by_record(page,block_record)
  nodesblocks.each do |node|
    #puts '---------------------------'
    #p node
    gorod=parser.attribute_by_record(node,gorod_record).strip
    next_href=parser.attribute_by_record(node,href_record)

    loader2.goto(starturi.join(next_href))
    parser2.document(loader2.html)
    page2=parser2.page

    nodesblocks2=parser2.nodes_by_record(page2,block_record3)
    nodesblocks2.each do |node2|
      firma=parser2.attribute_by_record(node2,firma_record).strip
      email=parser2.attribute_by_record(node2,email_record).gsub(/mailto:/,'').strip
      next_href2=parser3.attribute_by_record(node2,href_record3)
      loader4.goto(starturi.join(next_href2))
      www=loader4.html.scan(/"1;URL=([^"]*)"/).join('')
      puts '----------------------------------------'
      puts gorod
      puts firma
      puts email
      puts www
      arr=[gorod,firma,email,www]
      puts '++++++++++++++++++++++++++++++++++++++++++++'
      CSV.open(path+file, 'a:Windows-1251', {:col_sep=>";"})do |line|
        line << arr
      end
    end
    nodesblocks2=parser2.nodes_by_record(page2,block_record2)
    nodesblocks2.each do |node2|
      #puts '=========================='
      #p node2
      next_href2=parser2.attribute_by_record(node2,href_record2)
      loader3.goto(starturi.join(next_href2))
      parser3.document(loader3.html)
      page3=parser3.page
      nodesblocks3=parser3.nodes_by_record(page3,block_record3)
      nodesblocks3.each do |node3|
        firma=parser3.attribute_by_record(node3,firma_record).strip
        email=parser3.attribute_by_record(node3,email_record).gsub(/mailto:/,'').strip
        next_href3=parser3.attribute_by_record(node3,href_record3)
        loader4.goto(starturi.join(next_href3))
        www=loader4.html.scan(/"1;URL=([^"]*)"/).join('')
        puts '----------------------------------------'
        puts gorod
        puts firma
        puts email
        puts www
        arr=[gorod,firma,email,www]
        puts '++++++++++++++++++++++++++++++++++++++++++++'
        CSV.open(path+file, 'a:Windows-1251', {:col_sep=>";"})do |line|
          line << arr
        end
      end

    end
  end



end