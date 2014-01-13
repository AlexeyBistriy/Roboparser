
file=File.open('c:/temp/google.csv', 'r:UTF-8')
tmp=file.read
file.close
puts tmp
tmp.encode!('Windows-1251', invalid: :replace , undef: :replace)
File.open('c:/temp/table_google.csv', 'a:Windows-1251'){|file| file.write tmp}