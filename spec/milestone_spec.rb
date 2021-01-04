require "dartt/milestone"

RSpec.describe Dartt::Milestone do

  it "can create a milestone" do
    milestone = Dartt::Milestone.new("My Milestone", Date.new(2020, 12, 28))
    expect(milestone.name).to eq("My Milestone")
    expect(milestone.date).to eq(Date.new(2020, 12, 28))
  end

  it "moves the date to the weekday if it falls on a weekend" do
    milestone = Dartt::Milestone.new("My Milestone", Date.new(2020, 12, 27))
    expect(milestone.date).to eq(Date.new(2020, 12, 28))
  end

  it "responds to start" do
    milestone = Dartt::Milestone.new("My Milestone", Date.new(2021, 1, 4))
    expect(milestone.start).to eq(Date.new(2021, 1, 4))
  end

  it "responds to end" do
    milestone = Dartt::Milestone.new("My Milestone", Date.new(2021, 1, 4))
    expect(milestone.end).to eq(Date.new(2021, 1, 4))
  end

  it "can be set to start at the beginning of a day" do
    milestone = Dartt::Milestone.new("My Milestone", start_of: Date.new(2021, 1, 4))
    expect(milestone.date + 1).to eq(Date.new(2021, 1, 4))
  end
end
