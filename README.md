# Clusterpoint

Clusterpoint NoSQL database framework [cloud.clusterpoint.com](https://cloud.clusterpoint.com/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'clusterpoint'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install clusterpoint

Add railtie require to your application.rb file:
    
    require "cluster_point/railtie"


## Usage

### Database connection
Add cluster_point.yml file under config directory. Following format;

```
development:
    url: https://api.clusterpoint.com
    account_id: [Clusterpoint cloud api account ID]
    database: [Database to use]
    username: [Clusterpoint cloud username]
    password: [Clusterpoint cloud password]
    [debug_output: $stdout]
```

### Framework usage
To make model as Clusterpoint document innerhit it from `ClusterPoint::Document`

To define subdocuments you can use one of two options - `contains` (if contains single subdocument) or `contains_many` (if contains more than one subdocument):

```ruby
contains_many :translations
contains :author
```

Example:

```ruby
class Item < ClusterPoint::Document
  contains_many :translations
  contains_many :locations
  contains :author
end
```

### Basic operations
* `Item.all` - retrieve all documents with type Item (models are divided with document attribute `type`)
* `Item.find(id)` - retrieve document with ID = id
* `Item.new_from_hash(item_params.to_h)` - create new document from hash
* `@item.save` - save document
* `@item.update(item_params.to_h)` - update document and save changes
* `@item.destroy `- delete document
* `Item.where(query_hash, order_hash, record_count, start_offset)` - custom query.
  * `Item.where({code: "A*"}, {string: {code: :ascending}})`
  - More about query syntax:
    - http://docs.clusterpoint.com/wiki/Search_query_syntax
    - http://docs.clusterpoint.com/wiki/Alphabetic_Ordering

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/clusterpoint/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
