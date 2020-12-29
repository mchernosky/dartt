require "dartt/milestone"

RSpec.describe Dartt::Milestone do

  it "can create a milestone" do
    milestone = Dartt::Milestone.new("My Milestone", Date.new(2020, 12, 28))
    expect(milestone.name).to eq("My Milestone")
    expect(milestone.date).to eq(Date.new(2020, 12, 28))
  end
end
