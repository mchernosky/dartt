require 'victor'

module Dartt
  class Graph
    def initialize
      @svg = Victor::SVG.new viewBox: '0 0 1920 1080', style: { background: '#ddd' }
      @svg.rect x: 0, y: 0, width: 1920, height: 1080, rx: 5, fill: '#666'
    end
    def render
      @svg.render
    end
  end
end