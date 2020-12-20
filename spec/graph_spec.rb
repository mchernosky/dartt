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

  it "can define a new area" do
    graph = Dartt::Graph.new(width: 1920, height: 1080)
    graph.area(0,0,100,100)
  end

  it "can get the beginning width of the area" do
    graph = Dartt::Graph.new(width: 1920, height: 1080)
    x = graph.area(0,0,100,100) do
      w 0
    end
    expect(x).to eq(0)
  end

  it "can get the ending width of the area" do
    graph = Dartt::Graph.new(width: 1920, height: 1080)
    x = graph.area(0,0,100,100) do
      w 100
    end
    expect(x).to eq(1920)
  end

  it "can get the beginning width of the area with offset" do
    graph = Dartt::Graph.new(width: 1920, height: 1080)
    x = graph.area(10,0,100,100) do
      w 0
    end
    expect(x).to eq(192)
  end

  it "can get the ending width of the area with offset" do
    graph = Dartt::Graph.new(width: 1920, height: 1080)
    x = graph.area(10,0,100,100) do
      w 100
    end
    expect(x).to eq(1920)
  end

  it "can get the ending width of the area with margins" do
    graph = Dartt::Graph.new(width: 1920, height: 1080)
    x = graph.area(10,0,90,100) do
      w 100
    end
    expect(x).to eq(1728)
  end

  it "can get some width in the middle of an area" do
    graph = Dartt::Graph.new(width: 1920, height: 1080)
    x = graph.area(10,0,20,100) do
      w 50
    end
    expect(x).to eq(288)
  end

  it "can get some other width in the middle of an area" do
    graph = Dartt::Graph.new(width: 1920, height: 1080)
    x = graph.area(10,0,20,100) do
      w 40
    end
    expect(x).to eq(268.8)
  end
end