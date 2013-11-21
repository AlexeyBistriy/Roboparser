# coding: utf-8
module Robot
  class Menu
    include MyFile
    def initialize
      @tree=[]
    end
    attr_reader :tree
    def add(nodeset_a,uri,regexp='')
      nodeset_a.each do |element|
        if element.content&&element[:href]&&!element[:href].empty?&& url?(element[:href],regexp)
          @tree.push({:content=>element.content,:href=>uri.join(element[:href])})
        end
      end
    end
    def url?(url,regexp)
      if url=~/#{regexp}/
        true
      else
        false
      end
    end
    def save_to_file (path_dir,file_output,encoding='UTF-8')
      file=file_name_valid(file_output)
      path=path_dir
      path+='/' unless path=~/\/$/
      CSV.open(path+file, 'a:'+encoding)do |line|
        @tree.map do |item|
          line << [item[:content].sub(/\r|\n|/,' ').strip,item[:href]]
        end
      end
    end
  end

  class Data_set
    include MyFile
    def initialize
      @records=[]
      @values=[]
    end
    attr_reader :records
    attr_accessor :values
    def add (name,parse_method,key_parse,attribute,element_index=0)
      new_record=Record.new
      new_record.name=name
      new_record.method=parse_method
      new_record.key=key_parse
      new_record.attribute=attribute
      new_record.index=element_index
      if new_record.valid?
        @records.push(new_record)
        @values.push('')
      end
    end
    def head_save_to_file(path_dir,name_file,encoding='UTF-8')
      file=file_name_valid(name_file)
      path=path_dir
      path+='/' unless path=~/\/$/
      CSV.open( path+file, 'a:'+encoding)do |line|
        line << @records.map{|record| record.name}
      end
    end
    def save_to_file (path_dir,name_file,encoding='UTF-8')
      file=file_name_valid(name_file)
      path=path_dir
      path+='/' unless path=~/\/$/
      CSV.open(path+file, 'a:'+encoding)do |line|
        line << @values
      end
      #File.open(file_output, append){|file| file.write @data.map{|record| record.value}.join(" ")+"\n"}
    end
    def data_puts
      puts @values.join(' ')+"\n"
    end

  end
  class Record
    def initialize
      @name=nil
      @method=nil
      @key=nil
      @index=nil
      @attribute=nil
    end
    attr_accessor :name, :method, :key, :attribute, :index
    def valid?
      !(@name.nil?||@method.nil?||key.nil?||@attribute.nil?||@index.nil?)
    end
  end

end