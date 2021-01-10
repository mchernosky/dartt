# Dartt

Dartt is a tool for generating Gantt charts. Decribe your task with a Ruby internal DSL and generate Gantt chart images.

```ruby
require 'dartt'
require 'date'

Dartt.svg "blah" do
  
end
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dartt'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install dartt

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/dartt. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/dartt/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Dartt project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/dartt/blob/master/CODE_OF_CONDUCT.md).

## TODO

- Make section transparency configurable.
- Individual day highlighting.
- Custom styling for custom tags.
- Automatic chart sizing.
- Reference chart start/end for task dates.
- Allow dependencies on more than one task.
- Dates can be specified as strings instead of objects.

### Errors to handle

- Tasks placed outside chart dates.
- Task and milestone title run off the end of the chart.