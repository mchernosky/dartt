require 'dartt'
require 'date'

def save_svg(svg, name)
  File.open("../../spec/images/#{name}.svg", "w") { |f| f.write(svg) }
end

c = Dartt.chart "The Schedule", Date.new(2021, 1, 18), Date.new(2021, 4, 18) do
  section "Design"
  kickoff =           milestone "Kickoff Unblocked", start_of: Date.new(2021, 1, 18)
  register_review =   task "Register definition review", after: kickoff, days: 5
                      task "Technical design document", after: kickoff, days: 10
  design_review =     task "Design review and collaboration", after: register_review, days: 5
                      milestone "Design approved", after: design_review

  initial_app_setup = task "Initial application setup", after: design_review, days: 6
  interface_setup =   task "Interface setup", after: initial_app_setup, days: 8
  program_implement = task "Program implementation", after: interface_setup, days: 15
  test_config =       task "Test configuration", after: interface_setup, days: 5
                      task "User configuration", after: test_config, days: 8
  v01_delivery_prep = task "v0.1 delivery prep", after: program_implement, days: 7
                      milestone "v0.1 release delivered", after: v01_delivery_prep
end

save_svg(c.render, "example_chart")
