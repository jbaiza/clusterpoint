module ClusterPoint
  module Contains
    def contains(options = {})
      puts @contains_one_class
      if @contains_one_class == nil
        @contains_one_class = []
      end
      @contains_one_class << options
      puts "CONTAINS:" 
      puts @contains_one_class
      define_method(options.to_s.downcase+"_attributes=") do |argument|
        instance_variable_set( options.to_s.downcase, argument )
      end
    end
    def get_contains
      @contains_one_class
    end
  end
end