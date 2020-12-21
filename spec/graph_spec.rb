require "dartt/graph"

def save_svg(svg, name)
  File.open("spec/images/#{name}.svg", "w") { |f| f.write(svg) }
end

RSpec.describe Dartt::Graph do

  it "can create an image" do
    svg = Dartt::Graph.new.render
    expect(svg).to include("<svg")

    save_svg(svg, "blank")
  end

  it "can create an image with a rectangle" do
    svg = Dartt::Graph.new.render

    save_svg(svg,"rectangle")
  end
end