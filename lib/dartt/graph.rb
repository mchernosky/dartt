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
        #rect width:"100%", height:"100%", rx: 10, fill: '#aaa'
        # Draw the gridlines.
        days = 20
        x_spacing = 100.0/days
        (1..(days-1)).each do |day|
          puts x_spacing
          line x1:"#{x_spacing*day}%", y1:"0%", x2:"#{x_spacing*day}%", y2:"100%", stroke:"#666"
        end
        # A sample task bar.
        # duration = 3
        # rect x:"0%", y:"0%", width:"#{duration*x_spacing}%", height:50, fill:"blue"
        # text "Planning", x:"#{duration*x_spacing/2}%", y:25, font_size: 24
        draw_task("Planning2", 0, 1, 3, x_spacing, 'blue')
        # Another sample task bar.
        start = 5
        duration = 2
        row = 1
        draw_task("Demo2", row, start, duration, x_spacing, 'red')
        start = 7
        duration = 5
        row = 2
        draw_task("Integration", row, start, duration, x_spacing, "green")
      end

      # Axis
      svg x:"#{section_width}%", y:"#{100-title_height}%", width:"#{100-section_width}%", height:"#{title_height}%" do
        rect width:"100%", height:"100%", rx: 10, fill: 'blue'
        text "Axis", x: "50%", y: "50%"
      end
    end

    private

    def draw_task(name, row, start_day, duration, x_spacing, color)
      rect x: "#{(start_day - 1) * x_spacing}%", y: row * 50, width: "#{duration * x_spacing}%", height: 50, fill: color, rx: 5
      text name, x: "#{(start_day - 1) * x_spacing + duration * x_spacing / 2}%", y: row * 50 + (50 / 2), font_size: 24
    end

  end
end