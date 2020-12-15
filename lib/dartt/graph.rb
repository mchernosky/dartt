require 'victor'

module Dartt
  class Graph
    def initialize
      @svg = Victor::SVG.new
      @svg.rect x: 0, y: 10, width: 10, height: 10, rx: 5, fill: '#666'
    end
    def render
      @svg.render
    end
  end
end