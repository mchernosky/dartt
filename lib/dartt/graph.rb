require 'victor'
require 'pp'

module Dartt
  class Graph < Victor::SVG

    def initialize (title, total_days)
      @title = title
      @total_days = total_days

      @day_width = 100.0/@total_days

      @config = {
          :width => 1920,
          :height => 1080,
          :title_height => 108,
          :section_width => 384,
          :axis_height => 108,
          :task => {
              :height => 50,
              :vertical_margin => 2,
              :horizontal_margin => 2,
              :font_size => 20
          },
          :milestone => {
            :height => 50,
            :vertical_margin => 2,
            :rounding => 5,
            :font_size => 20
          }
      }

      @day_width_px = (@config[:width] - @config[:section_width]) / @total_days

          # Draw the parent SVG.
      super viewBox: "0 0 #{@config[:width]} #{@config[:height]}", font_family: 'arial', font_size: 40, fill: "white", text_anchor:"middle", dominant_baseline:"middle"

      # Draw the title.
      svg x:"0%", y:"0%", width:"100%", height:"10%" do
        text @title, x: "50%", y: "50%", fill: "black"
      end

      # Sections
      svg x:"0%", y:@config[:title_height], width:@config[:section_width], height:@config[:height] - @config[:title_height] do
        rect width:"100%", height:"100%", rx: 10, fill: '#666'
        text "Sections", x: "50%", y: "50%"
      end

        # Graph
      @graph = svg x:@config[:section_width], y:@config[:title_height], width:@config[:width] - @config[:section_width], height:@config[:height] - @config[:title_height]-@config[:axis_height] do
        #rect width:"100%", height:"100%", rx: 10, fill: '#aaa'
        # Draw the gridlines.
        (1..(@total_days-1)).each do |day|
          line x1:"#{@day_width*day}%", y1:"0%", x2:"#{@day_width*day}%", y2:"100%", stroke:"#666"
        end

      end

      # Axis
      svg x:@config[:section_width], y:@config[:height] - @config[:title_height], width:@config[:width] - @config[:section_width], height:@config[:axis_height] do
        rect width:"100%", height:"100%", rx: 10, fill: 'blue'
        text "Axis", x: "50%", y: "50%"
      end
    end

    def draw_task(name, row, start_day, duration)
      task_horizontal_margin_percent = @config[:task][:horizontal_margin].to_f/@config[:width]*100

      x = @config[:section_width] + ((start_day - 1) * @day_width_px) + @config[:task][:horizontal_margin]
      y = @config[:title_height]
      y += (row * @config[:task][:height]) + @config[:task][:vertical_margin]
      # TODO: Fix width calculation -- convert everyting to pixels.
      width = (duration * @day_width_px) - @config[:task][:horizontal_margin]
      height = @config[:task][:height] - 2*@config[:task][:vertical_margin]

      rect x: x, y: y, width: width, height: height, fill: "green", rx: 5
      text name, x: x + width/2, y: y + height/2, font_size: @config[:task][:font_size]
    end

    def draw_milestone(name, row, day)
      milestone_height = @config[:milestone][:height] - 2*@config[:milestone][:vertical_margin]
      milestone_side = Math.sqrt((milestone_height*milestone_height)/2)

      section_width_px = @config[:section_width]
      title_height_px = @config[:title_height]

      milestone_center_x = section_width_px + day * @day_width_px
      milestone_center_y = title_height_px + ((row * @config[:task][:height]) + (@config[:task][:height]/2))
      x = milestone_center_x - milestone_side/2
      y = milestone_center_y - milestone_side/2

      # Draw the milestone and rotate it to form a diamond.
      rect x:x, y:y, width:milestone_side, height:milestone_side,
           fill: 'blue',
           transform: "rotate (45 #{milestone_center_x} #{milestone_center_y})",
           rx: @config[:milestone][:rounding]
    end

    private

    def width_to_px(percent)
      percent.to_f*@config[:width]/100
    end

    def height_to_px(percent)
      percent.to_f*@config[:height]/100
    end
  end
end