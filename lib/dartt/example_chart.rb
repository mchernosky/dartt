require 'dartt/graph'
require 'dartt/task'
require 'dartt/milestone'
require 'date'

def save_svg(svg, name)
  File.open("../../spec/images/#{name}.svg", "w") { |f| f.write(svg) }
end

c = Dartt.chart "The Schedule", Date.new(2021, 1, 4), Date.new(2021, 3, 24) do
  milestone "v1.0 Delivery", Date.new(2021, 1, 7)
end

save_svg(c.render, "example_chart")
