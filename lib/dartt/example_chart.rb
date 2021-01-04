require 'dartt'
require 'date'

def save_svg(svg, name)
  File.open("../../spec/images/#{name}.svg", "w") { |f| f.write(svg) }
end

c = Dartt.chart "The Schedule", Date.new(2021, 1, 18), Date.new(2021, 3, 24) do
  kickoff =           milestone "Kickoff Unblocked", start_of: Date.new(2021, 1, 18)
  register_review =   task "Register definition review", after: kickoff, days: 5
                      task "Technical design document", after: kickoff, days: 10
  design_review =     task "Design review and collaboration", after: register_review, days: 5
                      milestone "Design approved", after: design_review
end

save_svg(c.render, "example_chart")
