# coding: utf-8
module Robot
  #'Nokogiri::HTML::Document'
  #'Nokogiri::XML::NodeSet'
  #'Nokogiri::XML::Element'
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
    def joiner_by_record(nodeset,record)
      attributes=[]
      atribute_empty=''
      if nodeset&&nodeset.is_a?(Nokogiri::XML::NodeSet)
        nodeset.each do |node|
          if record.attribute=='content'
            attributes.push(node.content) #if node.content
          else
            attributes.push(node[record.attribute.to_sym]) #if node[record.attribute.to_sym]
          end
        end
        attributes.join(record.joiner)
      else
        atribute_empty
      end
    end
    def attribute_by_record(doc_or_node,record)
      atribute_empty=''
      if doc_or_node&&(doc_or_node.is_a?(Nokogiri::HTML::Document)||doc_or_node.is_a?(Nokogiri::XML::NodeSet)||doc_or_node.is_a?(Nokogiri::XML::Element))
        case record.method
          when 'css'
            nodeset=doc_or_node.css(record.key)
            attribute(nodeset,record)
          when 'xpath'
            nodeset=doc_or_node.xpath(record.key)
            puts "+++++++++++++++++++++++++++++++++++++++++++++++++++++"
            puts "record.key = #{record.key}"
            puts "doc_or_node = #{doc_or_node.to_s}"
            puts nodeset.to_s
            attribute(nodeset,record)
          when "attribute"
            if record.attribute=='content'
              unless doc_or_node.content.nil?
                doc_or_node.content
              else
                atribute_empty
              end
            else
              unless doc_or_node[record.attribute].nil?
                doc_or_node[record.attribute]
              else
                atribute_empty
              end
            end
        end
      else
        atribute_empty
      end
    end
    def attribute_by_data(doc_or_node,dataset)
       dataset.records.map do|record|
         attribute_by_record(doc_or_node,record)
       end
    end
    def attribute(nodeset,record)
      attribute_empty=''
      unless record.index.nil?
        if nodeset&&nodeset.is_a?(Nokogiri::XML::NodeSet)
          unless nodeset.empty?
            unless nodeset[record.index].nil?
              if record.attribute=='content'
                 unless nodeset[record.index].content.nil?
                   nodeset[record.index].content
                 else
                   attribute_empty
                 end
              else
                unless nodeset[record.index].content.nil?
                  nodeset[record.index][record.attribute.to_sym]
                else
                  attribute_empty
                end
              end
            else
              attribute_empty
            end
          else
            attribute_empty
          end
        else
          attribute_empty
        end
      else
        joiner_by_record(nodeset,record)
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
