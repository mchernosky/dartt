
require 'dartt'
require 'date'

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
      task "A Task", start: Date.new(2021, 1, 4), days: 3
    end
    expect(c).to include(Dartt::Task.new("A Task").start(Date.new(2021, 1, 4)).duration(3))
  end

  it "can add a task with an end date and duration" do
    c = Dartt.chart "The Schedule" do
      task "A Task", end: Date.new(2021, 1, 8), days: 3
    end
    expect(c).to include(Dartt::Task.new("A Task").start(Date.new(2021, 1, 6)).duration(3))
  end

  it "can add a task with a start and end date" do
    c = Dartt.chart "The Schedule" do
      task "A Task", start: Date.new(2021, 1, 6), end: Date.new(2021, 1, 8)
    end
    expect(c).to include(Dartt::Task.new("A Task").start(Date.new(2021, 1, 6)).duration(3))
  end

  it "can add a task that occurs at the end of another task" do
    c = Dartt.chart "The Schedule" do
      first = task "First Task", start: Date.new(2021, 1, 4), days: 3
      task "Second Task", start: first.end, days: 3
    end
    expect(c).to include(Dartt::Task.new("Second Task").start(Date.new(2021, 1, 6)).duration(3))
  end

  it "can add a task that occurs after the end of another task" do
    c = Dartt.chart "The Schedule" do
      first = task "First Task", start: Date.new(2021, 1, 4), days: 3
      task "Second Task", after: first, days: 3
    end
    expect(c).to include(Dartt::Task.new("Second Task").start(Date.new(2021, 1, 7)).duration(3))
  end

  it "can add a task that occurs before the start of another task" do
    c = Dartt.chart "The Schedule" do
      second = task "Second Task", start: Date.new(2021, 1, 7), days: 3
      task "First Task", before: second, days: 3
    end

    expect(c).to include(Dartt::Task.new("First Task").start(Date.new(2021, 1, 4)).duration(3))
  end

  it "can add a milestone" do
    c = Dartt.chart "The Schedule" do
      milestone "v1.0 Delivery", date: Date.new(2021, 1, 7)
    end

    expect(c).to include(Dartt::Milestone.new("v1.0 Delivery", Date.new(2021, 1, 7)))
  end

  it "can add a milestone on the start of a date" do
    c = Dartt.chart "The Schedule" do
      milestone "v1.0 Delivery", start_of: Date.new(2021, 1, 7)
    end
    # The milestone should report that its date is the day before so it is drawn at the start of the next day.
    expect(c).to include(Dartt::Milestone.new("v1.0 Delivery", Date.new(2021, 1, 6)))
  end

  it "can add a task after a milestone" do
    c = Dartt.chart "The Schedule" do
      start = milestone "Start", date: Date.new(2021, 1, 4)
      task "First Task", after: start, days: 3
    end
    expect(c).to include(Dartt::Task.new("First Task").start(Date.new(2021, 1, 5)).duration(3))
  end

  it "can add a milestone after a task" do
    c = Dartt.chart "The Schedule" do
      t = task "First Task", start: Date.new(2021, 1, 4), days: 3
      milestone "First Task Complete", after: t
    end
    expect(c).to include(Dartt::Milestone.new("First Task Complete", Date.new(2021, 1, 6)))
  end

  it "can render a chart in one command" do
      Dartt.svg "The Schedule", Date.new(2021, 1, 4), Date.new(2021, 3, 29), "spec/images/svg-chart" do
        section "Phase 1"
        first_task = task "First Task", start: Date.new(2021, 1, 4), days: 20
        second_task = task "Second Task", after: first_task, days: 20
        milestone "Phase 1 Comlete", after: second_task

        section "Phase 2"
        final_task = task "Final Task", after: second_task, days: 10
        milestone "Phase 2 Complete", after: final_task
      end
      expect(File.exist?("spec/images/svg-chart.svg")).to be(true)
  end

  it "can add a tag to a task" do
    Dartt.chart "Project" do
      task "A Task", :done
    end
  end

  it "can add a tag to a task with other parameters" do
    Dartt.chart "Project" do
      task "A Task", :done, start: Date.new(2021, 1, 4), days: 5
    end
  end

  it "can add a tag to a milestone" do
    Dartt.chart "Project" do
      milestone "A Milestone", :done, date: Date.new(2021, 1, 4)
    end
  end

  it "can add a tag to a milestone after a task" do
    Dartt.chart "The Schedule" do
      t = task "First Task", start: Date.new(2021, 1, 4), days: 3
      milestone "First Task Complete", :done, after: t
    end
  end

  it "can add custom tags and configuration" do
    custom_config = {
        :title => {
            :font_color => "pink"
        },
        :tags => {
            :red => {
                :font_color => "white",
                :fill => "red",
                :line => "black",
            },
            :blue => {
                :font_color => "blue",
                :fill => "white",
                :line => "blue",
            }
        }
    }
    Dartt.svg "The Schedule", Date.new(2021, 1, 4), Date.new(2021, 3, 29), "spec/images/custom-tag", config: custom_config do
      first_task = task "First Task", start: Date.new(2021, 1, 4), days: 20
      second_task = task "Second Task", :red, after: first_task, days: 20
      milestone "Phase 1 Complete", :blue, after: second_task
    end
  end
end