require 'dartt'
require 'date'

def save_svg(svg, name)
  File.open("../../spec/images/#{name}.svg", "w") { |f| f.write(svg) }
end

c = Dartt.chart "The Schedule", Date.new(2021, 2, 18), Date.new(2021, 5, 20) do

  section "Design"
  kickoff =           milestone "Kickoff Unblocked", start_of: Date.new(2021, 2, 18)
  register_review =   task "Interface spec review", :done, after: kickoff, days: 5
                      task "Technical design", :done, after: kickoff, days: 10
  design_review =     task "Design review and collaboration", after: register_review, days: 5
                      milestone "Design approved", after: design_review

  section "Development"
  initial_app_setup = task "Initial application setup", after: design_review, days: 6
  interface_setup =   task "Interface setup", after: initial_app_setup, days: 8
  program_implement = task "Program implementation", after: interface_setup, days: 15
  test_config =       task "Test configuration", after: interface_setup, days: 5
  user_config =       task "User configuration", after: test_config, days: 20

  section "Release"
  v01_delivery_prep = task "v1.0 delivery prep", after: user_config, days: 7
                      milestone "v1.0 release delivered", after: v01_delivery_prep
end

save_svg(c.render, "example_chart")
