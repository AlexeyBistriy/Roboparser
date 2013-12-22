#coding: utf-8

require_relative './lib/init'
#
module Robot
  url='http://www.training.com.ua/company'
  path="./data/"
  file='trcomua.csv'
#
#
  starturi=Addressable::URI.parse('http://www.training.com.ua/').normalize
  baseuri=Addressable::URI.parse('http://www.training.com.ua/').normalize
#
  block_record=Record.new
  block_record.name='block'
  block_record.method='xpath'
  block_record.key='.//ins[@class="thumbnail"]/div[@class="r"]/span[@class="text_2"]/a'
  block_record.index=nil
  block_record.attribute=nil

  href_record=Record.new
  href_record.name='page'
  href_record.method='attribute'
  href_record.key=nil
  href_record.index=nil
  href_record.attribute='href'

  firma_record=Record.new
  firma_record.name='firma'
  firma_record.method='attribute'
  firma_record.key=nil
  firma_record.index=nil
  firma_record.attribute='content'

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

  loader5=Loader.new #'Windows-1251'
  parser5=NokoParser.new

  loader.goto(url)
  parser.document(loader.html)
  page=parser.page

  nodesblocks=parser.nodes_by_record(page,block_record)
  nodesblocks.each do |node|
    next_href=parser.attribute_by_record(node,href_record)
    firma=parser.attribute_by_record(node,firma_record)
    puts firma

    loader2.goto(starturi.join(next_href))
    parser2.document(loader2.html)
    page2=parser2.page

    nodesblocks2=parser2.nodes_by_record(page2,block_record2)
    nodesblocks2.each do |node2|

      host=parser2.attribute_by_record(node2,href_record2).strip


      puts host
      email=''
      contact=''
      unless host.empty?
        host='http://'+host unless host=~/^http:\/\//
        puts host
        loader3.goto(host)
        parser3.document(loader3.html)
        page3=parser3.page
        temp=Addressable::URI.parse(host).normalize
        nodeblock3=page3.css('a')
        nodeblock3.each do |node3|

          if node3.to_s=~/контакт|contact|нас найти/iu
            puts node3.to_s
            unless node3[:href].nil?
              contact=node3[:href]
              contact=temp.join(node3[:href]) unless node3[:href]=~/^http:\/\//
              loader5.goto(contact)
              parser5.document(loader5.html)
              if email==''
                email=loader5.html.scan(/\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}\b/).join(';')
              else
                email=email+';'+loader5.html.scan(/\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}\b/).join(';')
              end
            end
          end

        end
      end
      puts contact
      puts email
      puts '======================================================='
      arr=[firma,email,host,contact]
      puts '++++++++++++++++++++++++++++++++++++++++++++'
      CSV.open(path+file, 'a:UTF-8', {:col_sep=>";"})do |line|
        line << arr
      end
    end
  end

end