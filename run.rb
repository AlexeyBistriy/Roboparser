#coding: utf-8

#require_relative './lib/init'
#
#
#module Robot
#  url='https://www.google.com/search?&client=google-csbe'
#  request='Сало+мясо'
#  path="./data/"
#  file='google.csv'
#  database='google'
#  table='traning'
#  table2='link'
#
#  key=Key.new
#
#
#  hash_link={'link'=>'VARCHAR(255)'}
#  hash_fields={'firma'=>'VARCHAR(255)',
#               'email'=>'VARCHAR(255)',
#               'host'=>'VARCHAR(255)',
#               'site'=>'VARCHAR(255)',
#               'title'=>'VARCHAR(255)'}
#
#
#  #del_table2 database, table
#  #drop2 database
#  #create2 database
#  #puts '1'
#  #create_table2 database, table2, hash_link
#  #puts '2'
#  #create_table2 database, table2, hash_fields
#  #puts '3'
#  #
#  #record=['myfirma','email','myhost','mysite','mytitle']
#  #insert2 database, table, record
#  # show2
#
#  starturi=Addressable::URI.parse('http://www.training.com.ua/').normalize
#  baseuri=Addressable::URI.parse('http://www.training.com.ua/').normalize
#
#  block_record=Record.new
#  block_record.name='block'
#  block_record.method='xpath'
#  block_record.key='.//cite[@class="vurls"]'
#  block_record.index=nil
#  block_record.attribute=nil
#
#  href_record=Record.new
#  href_record.name='page'
#  href_record.method='attribute'
#  href_record.key=nil
#  href_record.index=nil
#  href_record.attribute='content'
#
#  pr=Proxy.new
#  loader=Loader.new  #'Windows-1251'
#  parser=NokoParser.new
#
#  loader2=LoaderWatir.new  #'Windows-1251'
#  parser2=NokoParser.new
#  pr.count=11
#  key.key_search.each do |search|
#    key.key_domains.each do |domain|
#      key.key_positions.each do |position|
#        seach_url=url+"&q="+request+"+"+search+"+"+"site:"+domain+"&"+position
#        puts seach_url
#        if pr.count>10
#          proxy=pr.shift
#          pr.verify?(proxy,seach_url)
#          sleep 120
#          pr.count=0
#        else
#          pr.count+=1
#        end
#        loader.goto(seach_url,proxy)
#        parser.document(loader.html)
#        page=parser.page
#        puts title=page.title.to_s.strip
#
#          if title=~/sorry/iu
#
#          end
#      end
#    end
#  end
#end

fiber = Fiber.new do
  x, y = 0, 1
  loop do
    Fiber.yield y
    x,y = y,x+y
  end
end

1000.times do
  puts fiber.resume
end


