# coding: utf-8
module Robot
  class NokoParser
    def initialize
      @page=nil
      #@type_element_out=nil  # page, block, variable, script
      #@methods_parse=nil  #css, xparse
    end
    attr_reader :page
    def xpath(node,key)
       node.xpath(key)
    end
    def css(node,key)
       node.css(key)
    end
    def document(html)
      @page=Nokogiri::HTML(html)
    end
    def parse_html(html)
      Nokogiri::HTML(html)
    end
    def nodes_by_record(doc_or_node,record)
      case record.method
        when 'css'
          doc_or_node.css(record.key)
        when 'xpath'
          doc_or_node.xpath(record.key)
      end
    end
    def attribute_by_record(doc_or_node,record)
      #puts '_______________________________'
      #puts doc_or_node.inspect
      #puts '_____________________________________'
      case record.method
        when 'css'
          nodeset=doc_or_node.css(record.key)
          unless attribute?(nodeset,record)
            attribute(nodeset,record)
          else
            ''
          end
        when 'xpath'
          nodeset=doc_or_node.xpath(record.key)
          unless attribute?(nodeset,record)
            attribute(nodeset,record)
          else
            ''
          end
        when "attribute"
          unless doc_or_node[record.attribute].nil?
            doc_or_node[record.attribute]
          end
      end

    end
    def attribute_by_data(doc_or_node,dataset)
       dataset.records.map do|record|
         attribute_by_record(doc_or_node,record)
       end
    end
    def attribute(nodeset,record)
      if record.attribute=='content'
        nodeset[record.index].content
      else
        nodeset[record.index][record.attribute.to_sym]
      end
    end
    def attribute?(nodeset,record)
      if record.attribute=='content'
        nodeset.nil?||nodeset.empty?||nodeset[record.index].nil?||nodeset[record.index].content.nil?
      else
        nodeset.nil?||nodeset.empty?||nodeset[record.index].nil?||nodeset[record.index][record.attribute.to_sym].nil?
      end
    end
    def regex(nodeset,attribute,regex)
      nodeset.find_all{|element| element[attribute]=~/#{regex}/}
    end
    def no_script(node)
      script=node.to_s
      tt=script.gsub /<script[^>]*>\s*document.write\(\'(?<sc>[^']+)\'\);<\/script>/u, '\k<sc>'
      html=tt.gsub('\"','"')
      Nokogiri::HTML(html)
    end
    def redirect?(title_regexp)
      text_title=page.css('title').text
      if text_title =~ /#{title_regexp}/
        true
      else
        false
      end
    end
  end

end
