# coding: utf-8
module Robot
    module MyFile
      def file_name_valid(name_file, os='Windows')
        if os=='Windows'
          name=name_file.gsub(/\&|\/|\\|\<|\>|\||\*|\?|\"|\n|\r|\:/u,' ').strip
        end
      end
    end
    include MyFile
    def self.send_to_mail(theme,body,email_to='alexeybistriy@gmail.com',email_from='newsvin@ukr.net')
      message=""
      message<<"From: My Rorbo <#{email_from}>\n"
      message<<"To: Alexey Bistriy <#{email_to}>\n"
      message<<"Subject: #{theme}\n"
      message<<body
      smtp=Net::SMTP.new('smtp.ukr.net',465)
      smtp.enable_tls
      smtp.start('localhost','newsvin@ukr.net','VVVVV',:plain) do |smtp|
        smtp.send_message message, email_from, email_to
      end
    end
    def self.save_to_csv (path_dir,name_file,encoding='UTF-8',array)
      file=file_name_valid(name_file)
      path=path_dir
      path+='/' unless path=~/\/$/
      CSV.open(path+file, 'a:'+encoding)do |line|
        line << array
      end
      #File.open(file_output, append){|file| file.write @data.map{|record| record.value}.join(" ")+"\n"}
    end

end