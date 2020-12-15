require "dartt/graph"

RSpec.describe Dartt::Graph do
  it "can create an image" do
    svg = Dartt::Graph.new.render
    expect(svg).to include("<svg")

    File.open("spec/images/blank.svg", "w") { |f| f.write(svg) }
  end

  it "can create an image with a rectangle" do
    svg = Dartt::Graph.new.render

    File.open("spec/images/rectangle.svg", "w") { |f| f.write(svg) }
  end
end