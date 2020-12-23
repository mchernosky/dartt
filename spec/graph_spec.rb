require "dartt/graph"

def save_svg(svg, name)
  File.open("spec/images/#{name}.svg", "w") { |f| f.write(svg) }
end

RSpec.describe Dartt::Graph do

  it "can create an svg chart" do
    chart = Dartt::Graph.new("test", 10).render
    expect(chart).to include("<svg")
  end

  it "can create an empty chart" do
    chart = Dartt::Graph.new("Empty Chart", 20).render
    save_svg(chart,"empty")
  end
end