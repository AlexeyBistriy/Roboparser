#coding: utf-8

#require_relative './lib/init'
#
#module Robot
#  url='http://www.msktreningi.ru/instructor/'
#  path="./data/"
#  file='msktrningi2.csv'
#
#
#  starturi=Addressable::URI.parse('http://www.msktreningi.ru/').normalize
#
#  block_record=Record.new
#  block_record.name='block'
#  block_record.method='xpath'
#  block_record.key='.//table/tr[1]/td[2]/blockquote/a'
#  block_record.index=nil
#  block_record.attribute=nil
#
#  href_record=Record.new
#  href_record.name='page'
#  href_record.method='attribute'
#  href_record.key=nil
#  href_record.index=nil
#  href_record.attribute='href'
#
#
#
#  block_record2=Record.new
#  block_record2.name='block2'
#  block_record2.method='xpath'
#  block_record2.key='.//li/blockquote/a'
#  block_record2.index=nil
#  block_record2.attribute=nil
#
#  href_record2=Record.new
#  href_record2.name='page2'
#  href_record2.method='attribute'
#  href_record2.key=nil
#  href_record2.index=nil
#  href_record2.attribute='href'
#
#  firma_record=Record.new
#  firma_record.name='firma'
#  firma_record.method='attribute'
#  firma_record.key=nil
#  firma_record.index=nil
#  firma_record.attribute='content'
#
#  email_record=Record.new
#  email_record.name='email'
#  email_record.method='xpath'
#  email_record.key='.//h1[1]'
#  email_record.index=nil
#  email_record.attribute='content'
#
#  loader=Loader.new  #'Windows-1251'
#  parser=NokoParser.new
#
#  loader2=Loader.new #'Windows-1251'
#  parser2=NokoParser.new
#
#  loader3=Loader.new #'Windows-1251'
#  parser3=NokoParser.new
#
#  loader.goto(url)
#  parser.document(loader.html)
#  page=parser.page
#
#  nodesblocks2=parser2.nodes_by_record(page,block_record2)
#  nodesblocks2.each do |node2|
#
#    next_href2=parser2.attribute_by_record(node2,href_record2)
#    firma=parser2.attribute_by_record(node2,firma_record)
#    loader3.goto(starturi.join(next_href2))
#    parser3.document(loader3.html)
#    page3=parser3.page
##    puts loader3.html
#    email=parser2.attribute_by_record(page3,email_record)
#    puts firma
#    puts email
#    arr=[firma,email,starturi.join(next_href2).to_s]
#    CSV.open(path+file, 'a:UTF-8', {:col_sep=>";"})do |line|
#      line << arr
#    end
#  end
#
#  nodesblocks=parser.nodes_by_record(page,block_record)
#  nodesblocks.each do |node|
#      next_href=parser.attribute_by_record(node,href_record)
#
#      loader2.goto(starturi.join(next_href))
#      parser2.document(loader2.html)
#      page2=parser2.page
#
#      nodesblocks2=parser2.nodes_by_record(page2,block_record2)
#      nodesblocks2.each do |node2|
#
#        next_href2=parser2.attribute_by_record(node2,href_record2)
#        firma=parser2.attribute_by_record(node2,firma_record)
#
#        loader3.goto(starturi.join(next_href2))
#        parser3.document(loader3.html)
#        page3=parser3.page
#        email=parser2.attribute_by_record(page3,email_record)
#        puts firma
#        puts email
#        arr=[firma,email,starturi.join(next_href2).to_s]
#        CSV.open(path+file, 'a:UTF-8', {:col_sep=>";"})do |line|
#          line << arr
#        end
#      end
#  end
#end
#
#
#
#
#
#
#
















file=File.open('c:\temp\msktrningi.csv', 'r:UTF-8')
tmp=file.read
file.close
puts tmp
tmp.encode!('Windows-1251', invalid: :replace , undef: :replace)
File.open('c:\temp\table_msktr.csv', 'a:Windows-1251'){|file| file.write tmp}