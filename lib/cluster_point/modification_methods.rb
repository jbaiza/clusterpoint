require 'securerandom'
require 'active_support'

module ClusterPoint
  module ModificationMethods
    def merge(params)
      params.each do | k, v|
        if self[k].kind_of? ClusterPoint::Document
          self[k].merge(v)
        elsif k.to_s.end_with? "_attributes"
          key=k.to_s[0..-12]
          #puts key
          h = ClusterPoint::HashMethods.remove_attribs(v.to_h)
          #puts "RRR:" + h.to_s
          if h.keys.include?('_destroy') || h.keys.include?(:_destroy)
            #puts 'TTT'
            klass = Object.const_get(key.classify)
            val = nil
            unless h['_destroy'] == "1" || h[:_destroy] == "1"
              val = klass.from_hash(h, klass)
            end
            self[key] = val
          else
            #puts "AAA"
            arr=[]
            klass = Object.const_get(key.classify)
            h.values.each do |val|
              unless val['_destroy'] == "1" || val[:_destroy] == "1"
                arr << klass.from_hash(val, klass)
              end
            end
            self[key] = arr
          end
        else
          self[k] = v
        end
        #puts k.to_s + ":" + v.to_s
      end
    end
    def update(params)
      self.merge(params)
      puts "UPDATE_AFTER:"+self.to_s
      get_cp.update(self)
      self.class.get(self.id)
    end
    def save
      if self["id"] != nil
        id = self["id"]
        get_cp.update(self)
      else
        id = SecureRandom.uuid
        self["id"] = id
        get_cp.insert(self)
      end
      self.class.get(id)
    end
    def destroy
      get_cp.delete(self["id"])
    end
  end
end