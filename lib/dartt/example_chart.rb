require 'dartt'
require 'date'

def save_svg(svg, name)
  File.open("../../spec/images/#{name}.svg", "w") { |f| f.write(svg) }
end

c = Dartt.chart "The Schedule", Date.new(2021, 1, 4), Date.new(2021, 3, 24) do
  # TODO: Fix that we can't start a task after a milestone on a monday.
  kickoff = milestone "Kickoff Unblocked", Date.new(2021, 1, 3)
  t = task "Register definition review", after: kickoff, duration: 5
  puts kickoff.start
  puts kickoff.end
  puts t.start
end

save_svg(c.render, "example_chart")
