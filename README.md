# Clusterpoint

Clusterpoint NoSQL database framework.

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
development:
  url: https://api.clusterpoint.com
  account_id: [Clusterpoint cloud api account ID]
  database: [Database to use]
  username: [Clusterpoint cloud username]
  password: [Clusterpoint cloud password]

### Framework usage
To make model as Clusterpoint document innerhit it from ClusterPoint::Document

To define subdocuments you can use one of two options - contains (if contains single subdocument) or contains_many (if contains more than one subdocument):
  contains_many :translations
  contains :author

Example:
class Item < ClusterPoint::Document
  contains_many :translations
  contains_many :locations
  contains :author
end

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/clusterpoint/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
