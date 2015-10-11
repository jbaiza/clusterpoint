require 'json'
module ClusterPoint
  module FinderMethods
      
    def all(ordering={string: {id: :ascending}})
      respToArray(JSON.parse(get_cp.where({type: self.to_s.upcase}, ordering)))
    end

    def where(conditions={}, ordering={string: {id: :ascending}}, docs=20, offset=0)
      conditions.merge!({type: self.to_s.upcase})
      respToArray(JSON.parse(get_cp.where(conditions, ordering, docs, offset)))
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
        self.from_hash(result["documents"][0], self)
      else
        raise RecordNotFound
      end
    end

    protected

    def get_some(ids)
      items = respToArray(JSON.parse(get_cp.where({type: self.to_s.upcase, id: "{" + ids.join(" ") + "}"}, docs: ids.size)))
      if items.size != ids.size
        raise RecordNotFound
      end
      items
    end

    protected
    def respToArray(json)
      items = []
      json["documents"].each do | value |
        ite = self.from_hash(value, self)
        items << ite
      end
      items
    end
  end
end