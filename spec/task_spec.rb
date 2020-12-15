
require "date"
require "mudhorn/task"

RSpec.describe Mudhorn::Task do

  describe "task creation" do

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
                 .duration(10)

      expect(task.duration).to eq(10)
    end
  end

  describe "calculating date and duration" do

    it "can get the end date" do
      task = Mudhorn::Task.new("My Task")
                 .start(Date.new(2020, 12, 10))
                 .duration(1)

      expect(task.end).to eq(Date.new(2020,12,10))
    end

    it "can get an end date that is not the start date" do
      task = Mudhorn::Task.new("My Task")
                 .start(Date.new(2020, 12, 9))
                 .duration(2)

      expect(task.end).to eq(Date.new(2020,12,10))
    end

    it "can get the start date after it is set" do
      task = Mudhorn::Task.new("My Task")
                 .start(Date.new(2020, 12, 9))
                 .duration(2)

      expect(task.start).to eq(Date.new(2020,12,9))
    end

    it "can get an end date that is in the next year" do
      task = Mudhorn::Task.new("My Task")
                 .start(Date.new(2020, 12, 28))
                 .duration(5)

      expect(task.end).to eq(Date.new(2021,1,1))
    end

    it "can be defined by an end date" do
      task = Mudhorn::Task.new("My Task")
                 .end(Date.new(2020,12,10))
                 .duration(2)

      expect(task.start).to eq(Date.new(2020,12,9))
    end

    it "can get the end date after it is set" do
      task = Mudhorn::Task.new("My Task")
                 .end(Date.new(2020,12,10))
                 .duration(2)

      expect(task.end).to eq(Date.new(2020,12,10))
    end

    it "can be defined by a start date and end date" do
      task = Mudhorn::Task.new("My Task")
          .start(Date.new(2020,12,8))
          .end(Date.new(2020,12,9))

      expect(task.duration).to eq(2)
    end
  end

  describe "excluding days" do

    it "skips the weekend when calculating end date" do
      task = Mudhorn::Task.new("My Task")
                   .start(Date.new(2020,12,11))
                   .duration(2)

      expect(task.end).to eq(Date.new(2020,12,14))
    end

    it "skips the weekend when calculating the duration" do
      task = Mudhorn::Task.new("My Task")
                 .start(Date.new(2020,12,11))
                 .end(Date.new(2020,12,14))

      expect(task.duration).to eq(2)
    end
    it "skips the weekend when calculating the start date" do
      task = Mudhorn::Task.new("My Task")
                 .end(Date.new(2020,12,14))
                 .duration(2)

      expect(task.start).to eq(Date.new(2020,12,11))
    end

    it "moves the start to the first weekday when starting on a weekend" do
      task = Mudhorn::Task.new("My Task")
                 .start(Date.new(2020,12,12))
                 .duration(2)

      expect(task.start).to eq(Date.new(2020,12,14))
    end

    # it "moves the end to the first weekday when on a weekend" do
    #   task = Mudhorn::Task.new("My Task")
    #              .end(Date.new(2020,12,12))
    #              .duration(2)
    #
    #   expect(task.end).to eq(Date.new(2020,12,14))
    # end

    # it "skips a single date when it is excluded" do
    #   Mudhorn::Task.exclude(Date.new(2020,12,9))
    #   task = Mudhorn::Task.new("My Task")
    #              .start(Date.new(2020,12,8))
    #              .duration(2)
    #
    #   expect(task.end).to eq(Date.new(2020,12,10))
    # end

    it "skips multiple days when they are excluded"

    it "skips weekend days when they are excluded"
  end

  describe "error handling" do
    it "raises an error when overconstrained by duration" do
      task = Mudhorn::Task.new("My Task")
                 .start(Date.new(2020,12,10))
                 .end(Date.new(2020,12,12))

      expect {
        task.duration(10)
      }.to raise_error(Mudhorn::TaskOverconstrained)
    end

    it "raises an error when overconstrained by end date" do
      task = Mudhorn::Task.new("My Task")
                 .start(Date.new(2020,12,10))
                 .duration(10)

      expect {
        task.end(Date.new(2020,12,12))
      }.to raise_error(Mudhorn::TaskOverconstrained)
    end

    it "raises an error when overconstrained by start date" do
      task = Mudhorn::Task.new("My Task")
                 .end(Date.new(2020,12,10))
                 .duration(10)

      expect {
        task.start(Date.new(2020,12,8))
      }.to raise_error(Mudhorn::TaskOverconstrained)
    end

    it "raises an error if the duraration is negative"
    it "raises an error if the duration is zero"
    it "raises an error when the start date is after the end date"
  end
end
