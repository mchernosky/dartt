require 'victor'

module Dartt

  class Graph
    def initialize (width: 1920, height: 1080)

      title_height = 10
      axis_height = 10
      section_width = 20
      title = "The Schedule"

      @svg = Victor::SVG.new viewBox: "0 0 #{width} #{height}", font_family: 'arial', font_size: 40, fill: "white", text_anchor:"middle", dominant_baseline:"middle" do
        # Title
        svg x:"0%", y:"0%", width:"100%", height:"10%" do
          rect width: "100%", height: "100%", rx: 10, fill: '#999'
          text title, x: "50%", y: "50%"
        end

        # Sections
        svg x:"0%", y:"10%", width:"25%", height:"90%" do
          rect width:"100%", height:"100%", rx: 10, fill: '#666'
          text "Sections", x: "50%", y: "50%"
        end

        # Graph
        svg x:"25%", y:"10%", width:"75%", height:"80%" do
          rect width:"100%", height:"100%", rx: 10, fill: '#aaa'
          text "Graph", x: "50%", y: "50%"
        end

        # Axis
        svg x:"25%", y:"90%", width:"75%", height:"10%" do
          rect width:"100%", height:"100%", rx: 10, fill: 'blue'
          text "Axis", x: "50%", y: "50%"
        end
      end
    end

    def render
      @svg.render
    end
  end
end