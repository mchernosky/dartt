require 'victor'
require 'pp'

module Dartt

  class Graph < Victor::SVG
    def initialize (title, width: 1920, height: 1080)
      @title = title
      @width = width
      @height = height

      title_height = 10
      axis_height = 10
      section_width = 20

      super viewBox: "0 0 #{@width} #{@height}", font_family: 'arial', font_size: 40, fill: "white", text_anchor:"middle", dominant_baseline:"middle"
      svg x:"0%", y:"0%", width:"100%", height:"10%" do
        rect width: "100%", height: "100%", rx: 10, fill: '#999'
        text @title, x: "50%", y: "50%"
      end

      # Sections
      svg x:"0%", y:"#{title_height}%", width:"#{section_width}%", height:"#{100-title_height}%" do
        rect width:"100%", height:"100%", rx: 10, fill: '#666'
        text "Sections", x: "50%", y: "50%"
      end

        # Graph
      svg x:"#{section_width}%", y:"#{title_height}%", width:"#{100-section_width}%", height:"#{100-title_height-axis_height}%" do
        rect width:"100%", height:"100%", rx: 10, fill: '#aaa'
        text "Graph", x: "50%", y: "50%"
      end

      # Axis
      svg x:"#{section_width}%", y:"#{100-title_height}%", width:"#{100-section_width}%", height:"#{title_height}%" do
        rect width:"100%", height:"100%", rx: 10, fill: 'blue'
        text "Axis", x: "50%", y: "50%"
      end
    end

  end
end