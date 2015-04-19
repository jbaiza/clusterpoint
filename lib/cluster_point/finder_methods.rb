require 'json'
module ClusterPoint
  module FinderMethods
      
    def all()
      respToArray(JSON.parse(get_cp.where({type: self.to_s.upcase})))
    end

    def find(*ids)

      expects_array = ids.first.kind_of?(Array)
      return ids.first if expects_array && ids.first.empty?
      
      ids = ids.flatten.compact.uniq

      case ids.size
      when 0
        raise 
      when 1
        result = get(ids.first)
        expects_array ? [ result ] : result
      else
        get_some(ids)
      end
    end

    def get(id)
      result = JSON.parse(get_cp.where({id: id, type: self.to_s.upcase}))
      if result["found"].to_i > 0
        self.from_hash(result["documents"][id], self)
      else
        raise RecordNotFound
      end
    end

    protected

    def get_some(ids)
      items = respToArray(JSON.parse(get_cp.where({type: self.to_s.upcase, id: "{" + ids.join(" ") + "}"}, ids.size, 0)))
      if items.size != ids.size
        raise RecordNotFound
      end
      items
    end

    protected
    def respToArray(json)
      items = []
      json["documents"].each do | key, value |
        ite = self.from_hash(value, self)
        items << ite
      end
      items
    end
  end
end