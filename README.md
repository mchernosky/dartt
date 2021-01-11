# Dartt

Dartt is a tool for generating Gantt charts from Ruby code.

You can describe your project tasks and milestones with a Ruby internal DSL and generate Gantt chart images.
It focuses on using simple dependencies and task lengths for defining everything, and most of the the chart options and layout are configurable.

Charts are generated as SVG images.

For example, this code:

```ruby
require 'dartt'
require 'date'

Dartt.svg "The Schedule", Date.new(2021, 1, 4), Date.new(2021, 3, 29), "svg-chart" do
    section "Phase 1"
    first_task = task "First Task", start: Date.new(2021, 1, 4), days: 20
    second_task = task "Second Task", after: first_task, days: 20
    milestone "Phase 1 Comlete", after: second_task

    section "Phase 2"
    final_task = task "Final Task", after: second_task, days: 10
    milestone "Phase 2 Complete", after: final_task
end
```

Produces this chart:
![Example chart](examples/simple-example.svg "An example chart")

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

### Creating charts

Create charts by requiring the `dartt` module and using the `svg` function of the module.

```ruby
Dartt.svg (title, start_date, end_date, filename) 
```

The arguments to the `svg` function are:

- `title` - The title of the chart.
- `start_date` - The first day of the chart.
- `end_date` - The last day of the chart.
- `filename` - The name of the svg file to create (do not include the `.svg` extension).

Note: The dates are provided as Ruby `Date` objects, so you will need to `require 'date'` as well.

The `svg` function takes a block will contain the chart.

```ruby
Dartt.svg "The Schedule", Date.new(2021, 1, 4), Date.new(2021, 3, 29), "svg-chart" do 
  # Define your tasks and milestones here.
end
```

All tasks and milestones drawn in the order in which they are listed in the chart.

### Tasks

Tasks are created using the `task` command.
The task command takes a variety of arguments to specify the start and end of a task.
This allows you to define tasks relative to other tasks, e.g. before or after other tasks.

Some ways to define tasks include:

| Definition | Example |
| --- | --- |
| A start date and duration | `task "Task 1", start: Date.new(2021, 1, 6), days: 3` |
| A start date and an end date | `task "Task 2", start: Date.new(2021, 1, 6), end: Date.new(2021, 1, 8)` |
| An end date and duration | `task "Task 3", end: Date.new(2021, 1, 8), days: 3` |
| After another task (with duration) | `task "Task 4", after: some_other_task, days: 3` |
| After another task (with end date) | `task "Task 4", after: some_other_task, end: Date.new(2021, 1, 8)` |
| Before another task (with duration) | `task "Task 5", before: some_other_task, days: 3` |
| Before another task (with start date) | `task "Task 5", start: Date.new(2021, 1, 6), before: some_other_task, days: 3` |

### Milestones

Milestones are defined with the `milestone` command.

Milestones can either be added with a specific date:

```ruby
milestone "v1.0 Delivery", Date.new(2021, 1, 8)
```

Or after some other task:

```ruby
milestone "v1.0 Delivery", after: some_other_task
```

### Sections

Sections group tasks and milestones together.
Sections are created with the `section` command.
All tasks and milestones added after defining a section are added to it until a new section is added.

```ruby
section "Section 1"
# All tasks and milestones added here are included in section 1.

section "Section 2"
# All tasks and milestones added here are included in section 1.
```

### A note on dates

All dates are "inclusive," for example:

- A task which begins on Jan 4 and lasts 2 days will end on Jan 5.
- A task with begins on Jan 4 and ends on Jan 5 has a duration of 2 days. 

When these tasks are drawn on the chart they will occupy two days worth of space.

The "end date" of both of these tasks is Jan 5.
If you started a new task on this end date, both tasks would overlap for a day (on Jan 5).
When defining a task relatively (with `before:` or )

### Weekends

By default, weekends are not included in any scheduling.
When calculating durations, weekends are skipped.
If a task is defined with a date that falls on a weekend, it is moved to the next weekday.

### Custom configuration


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

- Add `end` option to tasks.
- Remove section header area if there are no sections.
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