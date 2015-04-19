module ClusterPoint
  module Contains
    def contains(options = {})
      #puts @contains_one_class
      if @contains_one_class == nil
        @contains_one_class = []
      end
      unless @contains_one_class.include? options
        @contains_one_class << options
        #puts "CONTAINS:" 
        #puts @contains_one_class
        define_method(options.to_s+"_attributes=") do |argument|
          instance_variable_set( "@" + options.to_s, argument )
        end
      end
    end
    def get_contains
      @contains_one_class
    end
    def clear_contains
      @contains_one_class = nil
    end
  end
end