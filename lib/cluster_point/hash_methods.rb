require 'active_support'
require 'action_controller'

module ClusterPoint
  module HashMethods
    def from_hash(hash, klass)
      #puts "FROM_HASH:" + klass.to_s
      obj = klass.new(hash.except('_destroy'))
      if hash["id"]
        obj.id = hash["id"]
      end
      if hash[:id]
        obj.id = hash[:id]
      end
      if klass.get_contains_many
        #puts klass.get_contains_many
        klass.get_contains_many.each do |cont|
          key = cont.to_s
          exists = Object.const_get(cont.to_s.classify).is_a?(Class) rescue false
          if exists
            cont_klass = Object.const_get(cont.to_s.classify)
            arr = obj[key]
            unless arr == nil || arr == ""
              obj[key] = cont_klass.from_array(arr, cont_klass)
            else
              obj[key] = nil
            end
            #puts key
            #puts obj[key]
          end
        end
      end
      if klass.get_contains
        #puts klass.get_contains
        klass.get_contains.each do |cont|
          key = cont.to_s
          exists = Object.const_get(cont.to_s.classify).is_a?(Class) rescue false
          if exists
            cont_klass = Object.const_get(cont.to_s.classify)
            hash = obj[key]
            unless hash == nil || hash == ""
              obj[key] = cont_klass.from_hash(hash, cont_klass)
            else
              obj[key] = nil
            end
            #puts key
            #puts obj[key]
          end
        end
      end
      obj
    end

    def from_array(array, klass)      
      #puts "FROM_ARRAY:" + array.class.to_s + ":" + array.to_s
      arr = []
      if array != nil
        if array.class == Hash
          if like_array(array)
            #puts "FROM_ARRAY-LIKE_ARRAY"
            array.each do | key, value |
              unless value['_destroy'] == "1" || value[:_destroy] == "1"
                arr << klass.from_hash(value, klass)
              end
            end
          else
            #puts "FROM_ARRAY-HASH"
            unless array['_destroy'] == "1" || array[:_destroy] == "1"
              arr << klass.from_hash(array, klass)
            end
          end
        else
          #puts "FROM_ARRAY-ARRAY"
          array.each do | el |
            unless el['_destroy'] == "1" || el[:_destroy] == "1"
              arr << klass.from_hash(el, klass)
            end
          end
        end
      end
      arr
    end

    def like_array(doc)
      result = false
      if doc.class == Array
        result = true
      elsif doc.class == Hash
        keys = doc.keys.sort!
        if keys.size > 0
          match = true
          for i in 0..keys.size - 1
            unless keys[i].to_s.to_i.to_s == keys[i] && doc[keys[i]].class == Hash
              match = false
            end
          end
          result = match
        end
      end
      return result
    end

    def self.remove_attribs(h)
      h.keys.each do |k_s|
        #puts "REMOVE_ATTRIBS:"+k_s.to_s + ":" + h[k_s].class.to_s
        exists = Object.const_get(ActionController).is_a?(Class) rescue false
        if exists && h[k_s].class == ActionController::Parameters
          h[k_s] = h[k_s].to_h
        end
        if h[k_s].class == Hash
          h[k_s] == remove_attribs(h[k_s])
        end
        if(k_s.to_s.end_with? "_attributes")
            h[k_s.to_s[0..-12]] = h[k_s]
            h.delete(k_s)
        end
      end
      return h
    end
  end
end