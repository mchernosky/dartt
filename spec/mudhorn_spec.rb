require "date"
require "mudhorn/task"

RSpec.describe Mudhorn do
  it "has a version number" do
    expect(Mudhorn::VERSION).not_to be nil
  end

  it "can create a task with a name" do
    task = Mudhorn::Task.new("My Task")
    expect(task.name).to eq("My Task")
  end

  it "can set a start date" do
    task = Mudhorn::Task.new("My Task")
               .start(Date.new(2020, 12, 10))
    expect(task.start).to eq(Date.new(2020,12,10))
  end

  it "can set a duration" do
    task = Mudhorn::Task.new("My Task")
               .start(Date.new(2020, 12, 10))
               .set_duration(10)

    expect(task.duration).to eq(10)
  end

  it "can get the end date" do
    task = Mudhorn::Task.new("My Task")
               .start(Date.new(2020, 12, 10))
               .set_duration(1)

    expect(task.get_end).to eq(Date.new(2020,12,10))
  end

  it "can get an end date that is not the start date" do
    task = Mudhorn::Task.new("My Task")
               .start(Date.new(2020, 12, 10))
               .set_duration(2)

    expect(task.get_end).to eq(Date.new(2020,12,11))
  end

  it "can get an end date that is in the next year" do
    task = Mudhorn::Task.new("My Task")
               .start(Date.new(2020, 12, 31))
               .set_duration(5)

    expect(task.get_end).to eq(Date.new(2021,1,4))
  end

  it "can be defined by an end date" do
    task = Mudhorn::Task.new("My Task")
               .set_end(Date.new(2020,12,10))
               .set_duration(2)

    expect(task.get_start).to eq(Date.new(2020,12,9))
  end
end
