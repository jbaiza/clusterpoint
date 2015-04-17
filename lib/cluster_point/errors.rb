module ClusterPoint
  class ClusterPointError < StandardError
  end

  # Raised when cannot find record by given id or set of ids.
  class RecordNotFound < ClusterPointError
  end

  # Raised when no config found
  class ConfigurationNotFound < ClusterPointError
  end

  class AccountIdNotFound < ConfigurationNotFound
  end

  class DatabaseNotSet < ConfigurationNotFound
  end
end