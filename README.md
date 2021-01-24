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
| ---------- | ------- |
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
# All tasks and milestones added here are included in section 2.
```

### A note on dates

All dates are "inclusive," for example:

- A task which begins on Jan 4 and lasts 2 days will end on Jan 5.
- A task with begins on Jan 4 and ends on Jan 5 has a duration of 2 days. 

When these tasks are drawn on the chart they will occupy two days worth of space.

The "end date" of both of these tasks is Jan 5.
If you started a new task on this end date, both tasks would overlap for a day (on Jan 5).
When defining a task relatively (with `before:` or `after:`) the relative task is defined such that it does not overlap with the other task.

### Weekends

By default, weekends are not included in any scheduling.
When calculating durations, weekends are skipped.
If a task is defined with a date that falls on a weekend, it is moved to the next weekday.

### Custom configuration

Individual configuration settings can be overriden by providing a custom configuration hash.
Only the settings that you want to change need to be included.

For example, change the color of title like this:

```ruby
custom_config = {
  title => {
    :font_color => "pink"
  }
}

Dartt.svg "Title", Date.new(2021, 1, 4), Date.new(2021, 3, 29), "filename", config: custom_config do
 # Tasks and milestones go here.
end
```

### Custom styling with tags

Create custom tags by adding them to a custom configuration:

```ruby
custom_config = {
  :tags => {
    :red => {
      :font_color => "white",
      :fill => "red",
      :line => "black",
    },
    :blue => {
      :font_color => "blue",
      :fill => "white",
      :line => "blue",
    }
  }
}
```

Then you can tag a task or milestone and it will get the tag-specific styling:

```ruby
t = task "A Task", :red, start: Date.new(2021, 1, 4), days: 20
milestone "Task Complete", :blue, after: t
```

### Default configuration

This is the default configuration, and each of these can be overridden.

```ruby
{
  :width => 1920,
  :height => 1080,
  :title => {
    :height => 108,
    :font_color => "#003470",
  },
  :section => {
    :width => 300,
    :margin => 20,
    :color_1 => '#FFFDA2',
    :color_1_opacity => 0.4,
    :color_2 => 'white',
    :color_2_opacity => 0.0,
  },
  :axis => {
    :height => 80,
    :week_height => 32,
    :fill_color => '#D7D7D7',
    :line_color => 'white',
    :line_weight => 2,
    :weekend_color => '#E0E0E0',
    :grid_line_color => '#C1C1C1',
  },
  :task => {
    :height => 40,
    :vertical_margin => 3,
    :horizontal_margin => 0,
    :rounding => 5,
    :font_size => 20,
    :font_color => "#003470",
    :fill => "#77B7FF",
    :line => "#0D57AB",
    :line_weight => 2,
  },
  :milestone => {
    :height => 40,
    :vertical_margin => 2,
    :rounding => 4,
    :font_size => 20,
    :font_color => "#003470",
    :fill => "#77B7FF",
    :line => "#0D57AB",
    :line_weight => 2,
  },
  :tags => {
    :done => {
      :font_color => "#505050",
      :fill => "#d5d5d5",
      :line => "#505050",
    },
  },
}
```

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

- Automatic chart sizing.
- Reference chart start/end for task dates.
- Allow dependencies on more than one task.
- Dates can be specified as strings instead of objects.
- Individual day highlighting.
- Shift text to left at end of chart.
- Built in PNG conversion.

### Errors to handle

- Tasks placed outside chart dates.
- Task and milestone title run off the end of the chart.
