# coding: utf-8
#SET NAMES utf8 COLLATE utf8_unicode_ci

require 'mysql2'
database='joomlaz'


def create database
  begin
    client = Mysql2::Client.new(:host => "10.2.25.1", :username => "alexey", :password=>'', :port=>3306)
    results = client.query('SET NAMES utf8 COLLATE utf8_unicode_ci;')
    client.query("CREATE DATABASE IF NOT EXISTS #{database};")
      #rescue
      #  puts "eeeeeeee"

  ensure
    client.close if client
  end
end

def drop(database)
  begin
    client = Mysql2::Client.new(:host => "10.2.25.1", :username => "alexey", :password=>'', :port=>3306)
    results = client.query('SET NAMES utf8 COLLATE utf8_unicode_ci;')
    results =client.query("DROP DATABASE IF EXISTS #{database};")
      #rescue
      #  puts "eeeeeeee"
  ensure
    client.close if client
  end
end
def show
  begin
    client = Mysql2::Client.new(:host => "10.2.25.1", :username => "alexey", :password=>'', :port=>3306)
    results = client.query('SET NAMES utf8 COLLATE utf8_unicode_ci;')
    results =client.query("SHOW DATABASES;")
    results.each do |row|
      puts row
    end
      #rescue
      #  puts "eeeeeeee"
  ensure
    client.close if client
  end
end

def create_table database, table
  begin

    hash_fields={'title_shablon'=>'VARCHAR(255)','title'=>'VARCHAR(255)','tags'=>'VARCHAR(255)',
            'description'=>'TEXT','full_description'=>'TEXT','min_img'=>'BLOB',
            'max_img'=>'MEDIUMBLOB'}
    fields=hash_fields.to_a.map{|key,value|key+' '+value}.join(',')

    client = Mysql2::Client.new(:host => "10.2.25.1", :username => "alexey", :password=>'', :port=>3306,)
    results = client.query('SET NAMES utf8 COLLATE utf8_unicode_ci;')
    results = client.query("USE #{database}")
    results = client.query("CREATE TABLE IF NOT EXISTS #{table} (#{fields});")

    #results = client.query("DESCRIBE #{table};")
    #results.each do |row|
    #  puts row
    #end

       #rescue
       #puts "eeeeeeee"
  ensure
    client.close if client
  end
end
def del_table database, table
  begin

    hash_fields={'title_shablon'=>'VARCHAR(255)','title'=>'VARCHAR(255)','tags'=>'VARCHAR(255)',
                 'description'=>'TEXT','full_description'=>'TEXT','min_img'=>'BLOB',
                 'max_img'=>'MEDIUMBLOB'}
    fields=hash_fields.to_a.map{|key,value|key+' '+value}.join(',')

    client = Mysql2::Client.new(:host => "10.2.25.1", :username => "alexey", :password=>'', :port=>3306,)
    results = client.query('SET NAMES utf8 COLLATE utf8_unicode_ci;')
    results = client.query("USE #{database}")
    results = client.query("DROP TABLE IF EXISTS #{table} (#{fields});")

      #rescue
      #puts "eeeeeeee"
  ensure
    client.close if client
  end
end
show
create_table database, 'robo'