# coding: utf-8
#SET NAMES utf8 COLLATE utf8_unicode_ci
require 'mysql2'
begin

  client = Mysql2::Client.new(:host => "localhost", :username => "alexey", :password=>'', :port=>3306)
  results = client.query('show variables like "char%"')
  puts results.count
  results.each do |row|
    puts row.join(',')
  end
#rescue
#  puts "eeeeeeee"

ensure
client.close if client
end

