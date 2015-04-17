require 'securerandom'

module ClusterPoint
  module ModificationMethods
    def merge(params)
      params.each do | k, v|
        if v.kind_of? ClusterPoint::Document
          self[k].merge(v)
        elsif k.to_s.end_with? "_attributes"
          key=k.to_s[0..-12]
          puts key
          klass = Object.const_get(key[0..-2].capitalize)
          h = ClusterPoint::HashMethods.remove_attribs(v.to_h)
          puts "RRR:" + h.to_s
          arr=[]
          if h.keys.include?('_destroy')
            puts 'TTT'
            unless h['_destroy'] == "1"
              arr << klass.from_hash(h, klass)
            end
          else
            puts "AAA"
            h.values.each do |val|
              unless val['_destroy'] == "1"
                arr << klass.from_hash(val, klass)
              end
            end
          end
          self[key] = arr
        else
          self[k] = v
        end
        #puts k.to_s + ":" + v.to_s
      end
    end
    def update(params)
      self.merge(params)
      puts "UPDATE_AFTER:"+self.to_s
      getCp.update(self)
      self.class.get(self.id)
    end
    def save
      if self["id"] != nil
        id = self["id"]
        getCp.update(self)
      else
        id = SecureRandom.uuid
        self["id"] = id
        getCp.insert(self)
      end
      self.class.get(id)
    end
    def destroy
      getCp.delete(self["id"])
    end
  end
end