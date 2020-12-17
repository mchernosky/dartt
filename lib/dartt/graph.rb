require 'victor'

module Dartt
  class Graph
    def initialize
      @width = 1920
      @height = 1080
      title_height = 0.1
      axis_height = 0.1
      section_width = 0.2

      @svg = Victor::SVG.new viewBox: "0 0 #{@width} #{@height}", style: { background: '#ddd' }
      # Title
      @svg.rect x: 0, y: 0, width: @width, height: title_height*@height, rx: 5, fill: '#666'
      # Graph
      @svg.rect x: section_width*@width, y: title_height*@height, width: (1-section_width)*@width, height: (1-(title_height + axis_height))*@height, rx: 5, fill: '#999'
      # Axis
      @svg.rect x: section_width*@width, y: (1-axis_height)*@height, width: (1-section_width)*@width, height: axis_height*@height, rx: 5, fill: '#666'
    end
    def render
      @svg.render
    end
  end
end