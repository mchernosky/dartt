
require "dartt/graph"
require "dartt/task"

RSpec.describe Dartt::ChartBuilder do
  it "can create a chart" do
    c = Dartt::ChartBuilder.build "A Chart"
    expect(c).to be_a(Dartt::Chart)
  end

  it "can create a chart with a name" do
    c = Dartt::ChartBuilder.build "A Chart"
    expect(c.name).to eq("A Chart")
  end

  it "can add tasks to a chart" do
    c = Dartt::ChartBuilder.build "Three Month Project" do
      task "A Task"
    end
    expect(c.tasks).to include("A Task")
  end
end