# Active Credentials

Manage encrypted credentials (added in Rails 5.2.0) with multiple environments.

## Installation

Available as a gem [`active_credentials`](https://rubygems.org/gems/active_credentials)

## Usage

Using Rails command, generate new encrypted file by
```
bin/rails encrypted:edit config/credentials-production.yml.enc --key config/master-production.key
```
If `config/master-production.key` doesn't exist yet, run `bin/rails generate master_key` and adjust naming to match desired one.
Content of file can be displayed by
```
bin/rails encrypted:show config/credentials-production.yml.enc --key config/master-production.key
```

Add to `config/environments/production.rb` (or any other env)
```ruby
config.active_credentials = ActiveCredentials.new("config/credentials-production.yml.enc")
```

In the code:
```ruby
Rails.configuration.active_credentials.aws_access_key_id
```

To ease working in development/test environments with the same API, add `config/credentials-plain.yml` with key/value pairs
nested under environment name, like:
```yml
development:
  aws_access_key_id: "aws-key-id"
```

Then add to `config/environments/development.rb`
```ruby
config.active_credentials = ActiveCredentials.new("config/credentials-plain.yml", env: "development")
```

### Additions

* To raise error in case of missing key you can add bang to the name, like `Rails.configuration.active_storage.database_url!`
* To list all defined key/value pairs call `config`, like `Rails.configuration.active_storage.config`
* If `secret_key_base` is specified in credentials file, it will be assigned to `Rails.configuration.secret_key_base`, as it is required by Rails

## Development

[![Build Status](https://travis-ci.org/freeletics/active_credentials.svg?branch=master)](https://travis-ci.org/freeletics/active_credentials)

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/freeletics/active_credentials

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
