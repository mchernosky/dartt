require 'victor'
require 'pp'

module Dartt
  class Graph < Victor::SVG

    def initialize (title, total_days, width: 1920, height: 1080)
      @title = title
      @total_days = total_days
      @width = width
      @height = height

      @day_width = 100.0/@total_days

      # TODO: Turn these into config options in some hash/yaml.
      title_height = 10
      axis_height = 10
      section_width = 20

      # Draw the parent SVG.
      super viewBox: "0 0 #{@width} #{@height}", font_family: 'arial', font_size: 40, fill: "white", text_anchor:"middle", dominant_baseline:"middle"

      # Draw the title.
      svg x:"0%", y:"0%", width:"100%", height:"10%" do
        text @title, x: "50%", y: "50%", fill: "black"
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
        (1..(@total_days-1)).each do |day|
          line x1:"#{@day_width*day}%", y1:"0%", x2:"#{@day_width*day}%", y2:"100%", stroke:"#666"
        end
        # Create some sample task bars.
        draw_task("Planning2", 0, 1, 3)
        draw_task("Demo2", 1, 5, 2)
        draw_task("Integration", 2, 7, 5)
        draw_task("Planning", 3, 1, 10)
      end

      # Axis
      svg x:"#{section_width}%", y:"#{100-title_height}%", width:"#{100-section_width}%", height:"#{title_height}%" do
        rect width:"100%", height:"100%", rx: 10, fill: 'blue'
        text "Axis", x: "50%", y: "50%"
      end
    end

    private

    def draw_task(name, row, start_day, duration)
      task_height = 50
      rect x: "#{(start_day - 1) * @day_width}%", y: row * task_height, width: "#{duration * @day_width}%", height: task_height, fill: "green", rx: 5
      text name, x: "#{(start_day - 1) * @day_width + duration * @day_width / 2}%", y: row * task_height + (task_height / 2), font_size: 24
    end

  end
end