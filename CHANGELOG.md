# Overview

## 0.2.3

### New Features

* Exposed where method
* Added Clusterpoint order support (default order by ID ascending)
  - Item.where(query_hash, order_hash, record_count, start_offset)
  - Item.where({code: "A*"}, {string: {code: :ascending}})
  More about query syntax:
  - http://docs.clusterpoint.com/wiki/Search_query_syntax
  - http://docs.clusterpoint.com/wiki/Alphabetic_Ordering
* Moved HTTP request debug setting to configuration file
  debug_output: $stdout