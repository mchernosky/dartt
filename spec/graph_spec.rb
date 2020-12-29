require "dartt/graph"
require "dartt/task"

def save_svg(svg, name)
  File.open("spec/images/#{name}.svg", "w") { |f| f.write(svg) }
end

RSpec.describe Dartt::Graph do

  it "can create an svg chart" do
    chart = Dartt::Graph.new("test", Date.new(2021, 1, 4), Date.new(2021, 1, 14)).render
    expect(chart).to include("<svg")
  end

  it "can create an empty chart" do
    chart = Dartt::Graph.new("Empty Chart", Date.new(2021, 1, 4), Date.new(2021, 1, 24))
    save_svg(chart.render,"empty")
  end

  it "can create a chart with sections" do

    chart = Dartt::Graph.new("Sample Chart", Date.new(2021, 1, 4), Date.new(2021, 1, 24))

    # Create some sections.
    chart.add_section("Section 1", 0, 1)
    chart.add_section("Section 2", 2, 2)
    chart.add_section("Section 3", 3, 5)

    save_svg(chart.render,"sections")
  end

  it "can add date-based tasks" do
    chart = Dartt::Graph.new("Date-based Chart", Date.new(2021, 1, 4), Date.new(2021, 1, 24))
    chart.add_section("Section 1", 0, 1)
    chart.add(Dartt::Task.new("My Task")
                  .start(Date.new(2021, 1, 4))
                  .duration(3))
    chart.add(Dartt::Task.new("Another Task")
                  .start(Date.new(2021, 1, 7))
                  .duration(3))
    save_svg(chart.render,"date")
  end

  it "can add date-based tasks and milestones" do
    chart = Dartt::Graph.new("Date-based Chart", Date.new(2021, 1, 4), Date.new(2021, 1, 24))
    chart.add_section("Section 1", 0, 1)
    chart.add(Dartt::Task.new("My Task")
                  .start(Date.new(2021, 1, 4))
                  .duration(3))
    chart.add(Dartt::Milestone.new("Milestone", Date.new(2021, 1, 6)))
    save_svg(chart.render,"task-and-milestone")
  end
end