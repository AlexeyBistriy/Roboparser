module Robot
  # new gem mysql2
  def self.connect2
    begin
      connection = Mysql2::Client.new(:host => "10.2.25.1", :username => "alexey", :password=>'', :port=>3306)
      connection.query('SET NAMES utf8 COLLATE utf8_unicode_ci;')
      return connection unless block_given?
      yield connection
    rescue =>e
      puts e
    ensure
      connection.close if connection
    end
  end
  def self.show2
    connect2 do |con|
      results =con.query("SHOW DATABASES;")
      results.each do |row|
        puts row
      end
    end
  rescue =>e
    puts e
  end
  def self.create2(database)
    connect2 do |con|
      results =con.query("CREATE DATABASE IF NOT EXISTS #{database};")
    end
  rescue =>e
    puts e
  end
  def self.drop2(database)
    connect2 do |con|
      results =con.query("DROP DATABASE IF EXISTS #{database};")
    end
  rescue =>e
    puts e
  end
  def self.show_tables2 database
    connect2 do |con|
      results = con.query("USE #{database}")
      results =con.query("SHOW TABLES;")
      results.each do |row|
        puts row.class
      end
    end
  rescue =>e
    puts e
  end
  def self.create_table2 database, table, hash_fields
    #Example -=hash_fields=-
    #hash_fields={'title_shablon'=>'VARCHAR(255)',
    #             'title'=>'VARCHAR(255)',
    #             'tags'=>'VARCHAR(255)',
    #             'description'=>'TEXT',
    #             'full_description'=>'TEXT',
    #             'namw_min_img'=>'VARCHAR(255)',
    #             'name_max_img'=>'VARCHAR(255)'}

    fields=hash_fields.to_a.map{|key,value|key+' '+value}.join(',')
    connect2 do |con|
      results =con.query("USE #{database}")
      results =con.query("CREATE TABLE IF NOT EXISTS #{table} (#{fields});")
    end
  rescue =>e
    puts e
  end
  def self.del_table2 database, table
    connect2 do |con|
      results = con.query("USE #{database}")
      results = con.query("DROP TABLE IF EXISTS #{table};")
    end
  rescue =>e
    puts e
  end
  def self.insert2 database, table, record_array
    connect2 do |con|
      fields="'"+record_array.map{|element| con.escape(element)}.join("','")+"'"
      results = con.query("USE #{database}")
      results = con.query("INSERT INTO #{table} VALUES (#{fields});")
    end
  rescue
    puts e
  end
  def self.select2 database, table, field, value
    results=nil
    connect2 do |con|
      results = con.query("USE #{database}")
      results = con.query("Select * from #{table} WHERE (#{field}='#{value}');")
    end
    results
  rescue
    puts e
  end


end