#coding: utf-8

require_relative './lib/init'
#
module Robot
  url='https://www.google.com/search?&client=google-csbe'
  request='&q=тренинг'
  position='&start=0'
  path="./data/"
  file='google.csv'
  database='google'
  table='traning'

  hash_fields={'firma'=>'VARCHAR(255)',
               'email'=>'VARCHAR(255)',
               'host'=>'VARCHAR(255)',
               'site'=>'VARCHAR(255)',
               'title'=>'VARCHAR(255)'}
   key_words=["авторская",
              "агентство",
              "академия",
              "ассоциация",
              "бюро",
              "выбор",
              "высшая",
              "групп",
              "делового",
              "дизайна",
              "институт",
              "кадров",
              "капитал",
              "квалификации",
              "класс",
              "клуб",
              "коммуникаций",
              "компани",
              "консалт",
              "корпора",
              "коучинга",
              "курсы",
              "лаборатория",
              "лидерства",
              "личности",
              "маркетинга",
              "мастер",
              "международн",
              "менеджмент",
              "нлп",
              "новые",
              "ноу",
              "образов",
              "обучения",
              "ооо",
              "открытый",
              "партнер",
              "первый",
              "персонал",
              "повышения",
              "подготовки",
              "практик",
              "практической",
              "представительство",
              "при",
              "принцип",
              "продаж",
              "проект",
              "профессионального",
              "психологии",
              "психологическ",
              "развит",
              "ресурс",
              "решени",
              "роста",
              "семинары",
              "современных",
              "спб",
              "студия",
              "сфера",
              "технологи",
              "тренинг",
              "университет",
              "управления",
              "уральский",
              "учебный",
              "фирма",
              "центр",
              "школа",
              "экономики",
              "эксперт",
              "эффективного"].join('|')


  #del_table2 database, table
  #drop2 database
  #create2 database
  #puts '1'
  #create_table2 database, table, hash_fields
  #puts '2'
#
#
#  starturi=Addressable::URI.parse('http://www.training.com.ua/').normalize
#  baseuri=Addressable::URI.parse('http://www.training.com.ua/').normalize
#
  block_record=Record.new
  block_record.name='block'
  block_record.method='xpath'
  block_record.key='.//cite[@class="vurls"]'
  block_record.index=nil
  block_record.attribute=nil

  href_record=Record.new
  href_record.name='page'
  href_record.method='attribute'
  href_record.key=nil
  href_record.index=nil
  href_record.attribute='content'

  h1_record=Record.new
  h1_record.name='firma'
  h1_record.method='css'
  h1_record.key='h1'
  h1_record.index=0
  h1_record.attribute='content'

  h2_record=Record.new
  h2_record.name='firma'
  h2_record.method='css'
  h2_record.key='h2'
  h2_record.index=0
  h2_record.attribute='content'

  h3_record=Record.new
  h3_record.name='firma'
  h3_record.method='css'
  h3_record.key='h3'
  h3_record.index=0
  h3_record.attribute='content'

  block_record2=Record.new
  block_record2.name='block'
  block_record2.method='xpath'
  block_record2.key='.//div[@class="head11"]/div/span[@class="text_2"]/a[@target="_blank"]'
  block_record2.index=nil
  block_record2.attribute=nil

  href_record2=Record.new
  href_record2.name='page'
  href_record2.method='attribute'
  href_record2.key=nil
  href_record2.index=nil
  href_record2.attribute='content'




#
#  next_record=Record.new
#  next_record.name='page'
#  next_record.method='xpath'
#  next_record.key='.//a[@class="rightArrow"]'
#  next_record.index=nil
#  next_record.attribute='href'
#
##
  loader=Loader.new  #'Windows-1251'
  parser=NokoParser.new

  loader2=Loader.new #'Windows-1251'
  parser2=NokoParser.new

  loader3=Loader.new #'Windows-1251'
  parser3=NokoParser.new

  puts url+request+position
  loader.goto(url+request+position)
  parser.document(loader.html)
  page=parser.page
  #puts loader.html

  nodesblocks=parser.nodes_by_record(page,block_record)
  nodesblocks.each do |node|
    #puts node.to_s
    next_href=parser.attribute_by_record(node,href_record)
    host=next_href.scan(/^([^\/]*\/)/)[0][0]
    next_href='http://'+host
    host.gsub!(/^www\./,'')

    firma=''
    email=''
    contact=''
    title=''

    loader2.goto(next_href)
    parser2.document(loader2.html)
    page2=parser2.page
    title=page2.title

    h1=parser.attribute_by_record(page2,h1_record)
    h2=parser.attribute_by_record(page2,h2_record)
    h3=parser.attribute_by_record(page2,h3_record)
    if h1=~/#{key_words}/ui
      firma=h1
    elsif h2=~/#{key_words}/ui
      firma=h2
    elsif h3=~/#{key_words}/ui
      firma=h3
    else
      firma=''
    end

    temp=Addressable::URI.parse(next_href).normalize
    nodeblock2=page2.css('a')
    nodeblock2.each do |node2|
       if node2.to_s=~/контакт|contact|нас найти|наши координаты/iu
            #puts node2.to_s
            unless node2[:href].nil?
              contact=node2[:href]
              contact=temp.join(node2[:href]) unless node2[:href]=~/^http:\/\//
              loader3.goto(contact)

              if email==''
                email=loader3.html.scan(/\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}\b/).join(';')
              else
                email=email+';'+loader3.html.scan(/\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}\b/).join(';')
              end
            end
       end

    end

    mails=email.split(';')
    mails.uniq!
    email=mails.join(';')

    puts firma
    puts email
    puts host
    puts contact
    puts title

    puts '======================================================='

    arr=[firma,email,host,contact.to_str,title]

    record=[]
    record.push(firma)
    record.push(email)
    record.push(host)
    record.push(contact.to_str)
    record.push(title)
    insert2 database, table, record

    puts '++++++++++++++++++++++++++++++++++++++++++++'
    CSV.open(path+file, 'a:UTF-8', {:col_sep=>";"})do |line|
      line << arr
    end

  end

end



#
###
##
#file=File.open('c:/temp/trcomua.csv', 'r:UTF-8')
#tmp=file.read
#file.close
#puts tmp
#tmp.encode!('Windows-1251', invalid: :replace , undef: :replace)
#File.open('c:/temp/table_trcomua.csv', 'a:Windows-1251'){|file| file.write tmp}