require 'yaml'
require 'rails'
module ClusterPoint
  module Configuration
    def load_config
      @file = Rails.root ? Rails.root.to_s : "." + "/config/cluster_point.yml"
      @env = DEFAULT_ENV.call.to_s
      if !File.exists?(@file)
        raise ConfigurationNotFound
      end
      begin
        data = YAML.load_file(@file)
      rescue ArgumentError, Psych::SyntaxError => error
        raise Fixture::FormatError, "a YAML error occurred parsing #{@file}. Please note that YAML must be consistently indented using spaces. Tabs are not allowed. Please have a look at http://www.yaml.org/faq.html\nThe exact error was:\n  #{error.class}: #{error}", error.backtrace
      end
      if !data.has_key?(@env)
        raise ConfigurationNotFound
      end
      @config = data[@env]

      self.class.base_uri get_base_uri(@config)
    end

    def get_base_uri(config)
      host = config["url"] ? config["url"].sub(/(\/)+$/,'') : "https://api.clusterpoint.com"
      if !config.has_key?("account_id")
        raise AccountIdNotFound
      end
      if !config.has_key?("database")
        raise DatabaseNotSet
      end
      host + "/" + config["account_id"].to_s + "/" + config["database"].to_s
    end

  end
end