module ClusterPoint
  module JsonMethods
    def as_json(options = nil)
      result = '{'
      coma=''
      self.marshal_dump.each do |k,v| 
        if v.class == Array
          result += "#{coma}\"#{k}\":["
          coma_inner=''
          v.each do |ae|
            result += coma_inner
            result += ae.as_json(options)
            coma_inner=','
          end
          result += "]"
        elsif v != nil
          if v.kind_of? ClusterPoint::Document
            out = v.as_json
          else
            out='"' + v.gsub('"', '\"') + '"'
          end
          result += coma + '"' + k.to_s + '":' + out
        end
        coma=','
      end
      result += '}'
      result
    end
  end
end