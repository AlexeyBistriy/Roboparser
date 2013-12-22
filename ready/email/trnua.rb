#coding: utf-8

require_relative './lib/init'
#
module Robot
  url='http://www.trn.ua/companies/'
  path="./data/"
  file='trnua.csv'
#
#
  starturi=Addressable::URI.parse('http://www.trn.ua/companies/').normalize
  baseuri=Addressable::URI.parse('http://www.trn.ua/').normalize
#
  block_record=Record.new
  block_record.name='block'
  block_record.method='xpath'
  block_record.key='.//div[@class="letters"]/div/a'
  block_record.index=nil
  block_record.attribute=nil

  href_record=Record.new
  href_record.name='page'
  href_record.method='attribute'
  href_record.key=nil
  href_record.index=nil
  href_record.attribute='href'

  block_record2=Record.new
  block_record2.name='block2'
  block_record2.method='xpath'
  block_record2.key='.//div[@class="nf"]/a'
  block_record2.index=nil
  block_record2.attribute=nil

  href_record2=Record.new
  href_record2.name='page2'
  href_record2.method='attribute'
  href_record2.key=nil
  href_record2.index=nil
  href_record2.attribute='href'

#
  firma_record=Record.new
  firma_record.name='firma'
  firma_record.method='attribute'
  firma_record.key=nil
  firma_record.index=nil
  firma_record.attribute='content'
#


  host_record=Record.new
  host_record.name='email'
  host_record.method='xpath'
  host_record.key='.//noindex/a[@target="blank"]'
  host_record.index=nil
  host_record.attribute='content'

  contacts_record=Record.new
  contacts_record.name='email'
  contacts_record.method='css'
  contacts_record.key='a'
  contacts_record.index=nil
  contacts_record.attribute='content'

  href_record4=Record.new
  href_record4.name='page2'
  href_record4.method='css'
  href_record4.key='a'
  href_record4.index=nil
  href_record4.attribute='href'

  email_record=Record.new
  email_record.name='css'
  email_record.method='a'
  email_record.key='.//div[@class="items"]/div[@class="title-link"][2]/a'
  email_record.index=nil
  email_record.attribute='content'

#
#  #block_record2=Record.new
#  #block_record2.name='block2'
#  #block_record2.method='xpath'
#  #block_record2.key='.//li/strong/a'
#  #block_record2.index=nil
#  #block_record2.attribute=nil
#  #
#  #href_record2=Record.new
#  #href_record2.name='page2'
#  #href_record2.method='attribute'
#  #href_record2.key=nil
#  #href_record2.index=nil
#  #href_record2.attribute='href'
#
#
  loader=Loader.new  #'Windows-1251'
  parser=NokoParser.new

  loader2=Loader.new #'Windows-1251'
  parser2=NokoParser.new

  loader3=Loader.new #'Windows-1251'
  parser3=NokoParser.new

  loader4=Loader.new #'Windows-1251'
  parser4=NokoParser.new

  loader5=Loader.new #'Windows-1251'
  parser5=NokoParser.new


  loader.goto(url)
  parser.document(loader.html)
  page=parser.page







  nodesblocks=parser.nodes_by_record(page,block_record)
  nodesblocks.each do |node|
    next_href=parser.attribute_by_record(node,href_record)

    loader2.goto(starturi.join(next_href))
    parser2.document(loader2.html)
    page2=parser2.page

    nodesblocks2=parser2.nodes_by_record(page2,block_record2)
    nodesblocks2.each do |node2|

      firma=parser2.attribute_by_record(node2,firma_record)
      next_href2=parser2.attribute_by_record(node2,href_record2)

      loader3.goto(baseuri.join(next_href2))
      parser3.document(loader3.html)
      page3=parser3.page
      host=parser3.attribute_by_record(page3,host_record)
      puts baseuri.join(next_href)
      puts firma
      puts host
      email=''
      contact=''
      unless host.empty?
        loader4.goto(host)
        parser4.document(loader4.html)
        page4=parser4.page
        temp=Addressable::URI.parse(host).normalize
        nodeblock4=page4.css('a')
        nodeblock4.each do |node4|
          if node4.content=~/контакт|contact/ui
            unless node4[:href].nil?
              contact=temp.join(node4[:href])
              loader5.goto(contact)
              parser5.document(loader5.html)
              email=loader5.html.scan(/\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}\b/).join(';')
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
#