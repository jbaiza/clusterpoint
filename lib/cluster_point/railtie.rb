require "clusterpoint"
require "rails"

module ClusterPoint
  class Railtie < Rails::Railtie # :nodoc:
    config.eager_load_namespaces << ClusterPoint

  end
end
