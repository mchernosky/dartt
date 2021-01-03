
require "dartt/graph"
require "dartt/task"

RSpec.describe Dartt::Chart do
  it "can create a chart" do
    c = Dartt.chart "A Chart"
    expect(c).to be_a(Dartt::Chart)
  end

  it "can create a chart with a name" do
    c = Dartt.chart "A Chart"
    expect(c.name).to eq("A Chart")
  end

  it "can add a task to a chart" do
    c = Dartt.chart "Three Month Project" do
      task "A Task"
    end
    expect(c).to include(Dartt::Task.new("A Task"))
  end

  it "can add multiple tasks to a chart" do
    c = Dartt.chart "Three Month Project" do
      task "A Task"
      task "Another Task"
    end
    expect(c).to include(Dartt::Task.new("A Task"))
    expect(c).to include(Dartt::Task.new("Another Task"))
  end

  it "doesn't have tasks that have not been added" do
    c = Dartt.chart "Three Month Project" do
      task "A Task"
    end
    expect(c).to include(Dartt::Task.new("A Task"))
    expect(c).not_to include(Dartt::Task.new("Task Not Added"))
  end
end