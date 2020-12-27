require "dartt/graph"

def save_svg(svg, name)
  File.open("spec/images/#{name}.svg", "w") { |f| f.write(svg) }
end

RSpec.describe Dartt::Graph do

  it "can create an svg chart" do
    chart = Dartt::Graph.new("test", 10).render
    expect(chart).to include("<svg")
  end

  it "can create an empty chart" do
    chart = Dartt::Graph.new("Empty Chart", 20)
    # Create some sample task bars.
    chart.draw_task("Planning 2", 0, 1, 3)
    chart.draw_task("Demo 2", 4, 5, 2)
    chart.draw_task("Integration", 2, 7, 5)
    chart.draw_task("Planning", 3, 1, 10)

    chart.draw_milestone("Delivery 1", 1, 3)
    save_svg(chart.render,"empty")
  end
end