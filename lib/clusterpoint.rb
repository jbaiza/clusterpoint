require "cluster_point/version"
require 'active_support'

module ClusterPoint
  extend ActiveSupport::Autoload

  autoload :ClusterPointError, 'cluster_point/errors'
  autoload :RecordNotFound, 'cluster_point/errors'
  autoload :Configuration

  eager_autoload do
    autoload :Document
    autoload :FinderMethods
    autoload :HashMethods
    autoload :JsonMethods
    autoload :ModificationMethods
    autoload :ClusterPointAdapter
    autoload :Contains
    autoload :ContainsMany

  end

end