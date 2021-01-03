
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

  it "can add a task with a start date" do
    c = Dartt.chart "The Schedule" do
      task "A Task", start: Date.new(2021, 1, 4)
    end
    expect(c).to include(Dartt::Task.new("A Task").start(Date.new(2021, 1, 4)))
  end

  it "can add a task with a start date and duration" do
    c = Dartt.chart "The Schedule" do
      task "A Task", start: Date.new(2021, 1, 4), duration: 3
    end
    expect(c).to include(Dartt::Task.new("A Task").start(Date.new(2021, 1, 4)).duration(3))
  end

  it "can add a task that occurs at the end of another task" do
    c = Dartt.chart "The Schedule" do
      first = task "First Task", start: Date.new(2021, 1, 4), duration: 3
      task "Second Task", start: first.end, duration: 3
    end
    expect(c).to include(Dartt::Task.new("Second Task").start(Date.new(2021, 1, 6)).duration(3))
  end
end