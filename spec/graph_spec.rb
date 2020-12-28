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
    chart = Dartt::Graph.new("The Schedule", 20)
    # Create some sections.
    chart.add_section("Section 1", 0, 1)
    chart.add_section("Section 2", 2, 2)
    chart.add_section("Section 3", 3, 5)


    # Create some sample task bars.
    chart.add_task("Planning 2", 1, 3)
    chart.add_task("Demo 2", 5, 2)
    chart.add_task("Integration", 7, 5)
    chart.add_task("Planning", 1, 10)

    # chart.draw_milestone("Delivery 1", 1, 3)
    save_svg(chart.render,"empty")
  end
end