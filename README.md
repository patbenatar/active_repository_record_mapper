# ActiveRepositoryRecordMapper

Some sort of hybrid attempt at achieving the separation of concerns from
Data Mapper or Repository pattern with the convenience and robustness of
Rails' ActiveRecord.

## Installation

```ruby
gem 'active_repository_record_mapper'
```

## Usage

```ruby
class UsersRepository < ActiveRepositoryRecordMapper::Repository
  table 'users'

  scope :over_18, -> { where('age >= ?', 18) }
end

user_data = UsersRepository.find(1)
# => hash of user data

adults = UsersRepository.over_18
# => set of hashes of user data
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/patbenatar/active_repository_record_mapper.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

