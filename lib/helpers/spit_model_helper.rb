module SpitModel
  module SpitModelHelper
    def spit_model(obj, options={})
      attributes = obj.attributes
      
      if options[:except]
        exceptions = [*options[:except]]
        
        attributes = obj.attributes.reject do |k,v|
          exceptions.any? do |exception|
            if exception.is_a?(String)
              k == exception
            elsif exception.is_a?(Regexp)
              k =~ exception
            end
          end
        end
      end
        
      doc = ::Builder::XmlMarkup.new(:indent => 2)
      doc.table do      
        attributes.each do |name,value|
          doc.tr do
            doc.td h(nicer_name_for_attribute(name))
            doc.td h(nicer_value_for_attribute(obj, name, value))
          end
        end
      end
    end
    
    def nicer_name_for_attribute(name)
      name.sub(/_id$/,'').titleize
    end
    
    def nicer_value_for_attribute(obj, name, value)
      if name =~ /_id$/
        "#{obj.send(name.sub(/_id$/,'')).try(:name)} (ID: #{value})"
      else
        value
      end
    end
  end
end