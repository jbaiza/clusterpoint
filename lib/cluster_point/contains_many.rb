module ClusterPoint
  module ContainsMany
    def contains_many(options = {})
      #puts @contains_many_class
      if @contains_many_class == nil
        @contains_many_class = []
      end
      unless @contains_many_class.include? options
        @contains_many_class << options
        #puts "CONTAINS_MANY:" 
        #puts @contains_many_class
        #puts self.object_id
        define_method(options.to_s.downcase+"s_attributes=") do |argument|
          instance_variable_set( options.to_s.downcase+"s" , argument )
        end
      end
    end
    def get_contains_many
      @contains_many_class
    end
  end
end