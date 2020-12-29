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

  it "can add two sequential tasks" do
    chart = Dartt::Graph.new("Two Sequential Tasks", Date.new(2021, 1, 4), Date.new(2021, 1, 24))
    chart.add_section("Section 1", 0, 1)
    chart.add(Dartt::Task.new("First Task")
                  .start(Date.new(2021, 1, 4))
                  .duration(3))
    chart.add(Dartt::Task.new("Second Task")
                  .start(Date.new(2021, 1, 7))
                  .duration(3))
    save_svg(chart.render,"sequential-tasks")
  end

  it "can add date-based tasks and milestones" do
    chart = Dartt::Graph.new("Task and Milestone", Date.new(2021, 1, 4), Date.new(2021, 1, 24))
    chart.add_section("Section 1", 0, 1)
    chart.add(Dartt::Task.new("My Task")
                  .start(Date.new(2021, 1, 4))
                  .duration(3))
    chart.add(Dartt::Milestone.new("Milestone", Date.new(2021, 1, 6)))
    save_svg(chart.render,"task-and-milestone")
  end

  it "can draw a chart over 3 months" do
    chart = Dartt::Graph.new("Three Month Project", Date.new(2021, 1, 4), Date.new(2021, 4, 10))
    chart.add_section("Section 1", 0, 1)
    chart.add_section("Section 2", 2, 5)
    chart.add(Dartt::Task.new("Task 1")
                  .start(Date.new(2021, 1, 4))
                  .duration(15))
    chart.add(Dartt::Milestone.new("Milestone", Date.new(2021, 1, 22)))
    chart.add(Dartt::Task.new("Task 2")
                  .start(Date.new(2021, 1, 23))
                  .duration(14))
    chart.add(Dartt::Task.new("Task 3")
                  .start(Date.new(2021, 2, 12))
                  .duration(20))
    chart.add(Dartt::Task.new("Task 4")
                  .start(Date.new(2021, 3, 12))
                  .duration(15))
    chart.add(Dartt::Milestone.new("Milestone", Date.new(2021, 4, 1)))
    save_svg(chart.render,"three-month-project")
  end
end