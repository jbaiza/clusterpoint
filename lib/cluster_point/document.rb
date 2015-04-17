require 'ostruct'
require 'active_model'
module ClusterPoint
  class Document < OpenStruct
    include ActiveModel::Validations
    include ActiveModel::Conversion
    extend  ActiveModel::Naming

    extend ClusterPoint::FinderMethods
    extend ClusterPoint::HashMethods
    extend ClusterPoint::Contains
    extend ClusterPoint::ContainsMany
    include ClusterPoint::JsonMethods
    include ClusterPoint::ModificationMethods

    attr_accessor :id, :type

    def self.getCp
      if @cp == nil
        @cp = ClusterPoint::ClusterPointAdapter.new
      end
      @cp
    end

    def getCp
      if @cp == nil
        @cp = ClusterPoint::ClusterPointAdapter.new
      end
      @cp
    end

    def self.new_from_hash(hash)
      doc=self.from_hash(hash, self)
      doc["type"] = self.to_s.upcase
      doc
    end

    def persisted?
      id != nil
    end

  end
end