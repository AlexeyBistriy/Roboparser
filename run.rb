#coding: utf-8

require_relative './lib/init'

#
module Robot
  url='https://www.google.com/search?&client=google-csbe'
  request='тренинги'
  path="./data/"
  file='google.csv'
  database='google'
  table='traning'
  table2='link'

  key=Key.new


   hash_link={'link'=>'VARCHAR(255)'}
   hash_fields={'firma'=>'VARCHAR(255)',
               'email'=>'VARCHAR(255)',
               'host'=>'VARCHAR(255)',
               'site'=>'VARCHAR(255)',
               'title'=>'VARCHAR(255)'}


  #del_table2 database, table
  #drop2 database
  #create2 database
  #puts '1'
  #create_table2 database, table2, hash_link
  #puts '2'
  #create_table2 database, table2, hash_fields
  #puts '3'
  #
  #record=['myfirma','email','myhost','mysite','mytitle']
  #insert2 database, table, record


  starturi=Addressable::URI.parse('http://www.training.com.ua/').normalize
  baseuri=Addressable::URI.parse('http://www.training.com.ua/').normalize

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




  loader=Loader.new  #'Windows-1251'
  parser=NokoParser.new

  loader2=Loader.new #'Windows-1251'
  parser2=NokoParser.new

  loader3=Loader.new #'Windows-1251'
  parser3=NokoParser.new
  #
  pr=Proxy.new
  pr.count=120
  key.key_search.each do |search|
    key.key_domains.each do |domain|
      key.key_positions.each do |position|

        seach_url=url+"&q="+request+"+"+search+"+"+"site:"+domain+"&"+position
        linker=select2 database, table2, 'link', seach_url
        unless linker.count==0
          puts "уже грузили #{seach_url}"
        else

          #if pr.count<120
          #   pr.count+=1
          #else
          #  proxy=pr.get_proxy(seach_url)
          #  pr.count=0
          #end
          puts seach_url
          link=[seach_url]
          insert2 database, table2, link
          loader.goto(seach_url)
          parser.document(loader.html)
          page=parser.page
          #puts loader.html

          nodesblocks=parser.nodes_by_record(page,block_record)
          nodesblocks.each do |node|
            #puts node.to_s
            next_href=parser.attribute_by_record(node,href_record)
            if next_href=~/https:\/\//
              host=next_href.scan(/^(https:\/\/[^\/]*\/)/).join
              next_href='https://'+host
              host.gsub!(/^www\./,'')
            else
              host=next_href.scan(/^([^\/]*\/)/).join
              next_href='http://'+host
              host.gsub!(/^www\./,'')
            end

            puts host
            selector=select2 database, table, 'host', host
            if selector.count==0 and host!=''
              firma=''
              email=''
              contact=''
              title=''
              begin
                loader2.goto(next_href)
                parser2.document(loader2.html)
                page2=parser2.page
                title=page2.title.to_s.strip

                #h1=parser.attribute_by_record(page2,h1_record)
                #h2=parser.attribute_by_record(page2,h2_record)
                #h3=parser.attribute_by_record(page2,h3_record)
                #key_word=key.key_words.join('|')
                #if h1=~/#{key_word}/ui
                #  firma=h1.strip
                #elsif h2=~/#{key_word}/ui
                #  firma=h2.strip
                #elsif h3=~/#{key_word}/ui
                #  firma=h3.strip
                #else
                #  firma=''
                #end
                firma=''

                temp=Addressable::URI.parse(next_href).normalize
                nodeblock2=page2.css('a')
                nodeblock2.each do |node2|
                   if node2.to_s=~/контакт|contact|нас найти|наши координаты/iu
                        #puts node2.to_s
                        unless node2[:href].nil?
                          contact=node2[:href]
                          contact=temp.join(node2[:href]) unless node2[:href]=~/^http(s)?:\/\//
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
              rescue
                puts 'skip bug host'
              end
            end
          end

        end
      end
    end
  end
end



#
###
##
#file=File.open('c:/temp/google.csv', 'r:UTF-8')
#tmp=file.read
#file.close
#puts tmp
#tmp.encode!('Windows-1251', invalid: :replace , undef: :replace)
#File.open('c:/temp/table_google.csv', 'a:Windows-1251'){|file| file.write tmp}