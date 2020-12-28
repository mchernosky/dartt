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
          :section_width => 300,
          :section_margin => 20,
          :axis_height => 108,
          :task => {
              :height => 50,
              :vertical_margin => 3,
              :horizontal_margin => 3,
              :rounding => 5,
              :font_size => 20,
              :font_color => "#003470",
              :fill => "#77B7FF",
              :line => "#0D57AB",
              :line_weight => 3,
          },
          :milestone => {
            :height => 50,
            :vertical_margin => 2,
            :rounding => 4,
            :font_size => 20,
            :font_color => "#003470",
            :fill => "#77B7FF",
            :line => "#0D57AB",
            :line_weight => 3,
          }
      }

      @day_width_px = (@config[:width] - @config[:section_width]) / @total_days

          # Draw the parent SVG.
      super viewBox: "0 0 #{@config[:width]} #{@config[:height]}", font_family: 'arial', font_size: 40, fill: "white", text_anchor:"middle", dominant_baseline:"middle"

      # Draw the title.
      svg x:"0%", y:"0%", width:"100%", height:"10%" do
        text @title, x: "50%", y: "50%", fill: "black"
      end

      # Grid lines
      x_position = @config[:section_width]
      (1..(@total_days-1)).each do |day|
        x_position += @day_width_px
        line x1:x_position, y1:@config[:title_height], x2:x_position, y2:@config[:height] - @config[:axis_height], stroke:"#666"
      end
      # Axis
      svg x:@config[:section_width], y:@config[:height] - @config[:title_height], width:@config[:width] - @config[:section_width], height:@config[:axis_height] do
        rect width:"100%", height:"100%", rx: 10, fill: 'blue'
        text "Axis", x: "50%", y: "50%"
      end
    end

    def draw_section(name, start_row, end_row)
      y = @config[:title_height] + start_row*@config[:task][:height]
      height = (end_row-start_row+1)*@config[:task][:height]
      rect x: "0%", y: y, width: "100%", height: height, fill: '#EFFC7F'
      text name, x:@config[:section_marginK], y: y+height/2, text_anchor:'start', fill:'black', font_size: 24
    end

    def draw_task(name, row, start_day, duration)
      task_horizontal_margin_percent = @config[:task][:horizontal_margin].to_f/@config[:width]*100

      x = @config[:section_width] + ((start_day - 1) * @day_width_px) + @config[:task][:horizontal_margin]
      y = @config[:title_height]
      y += (row * @config[:task][:height]) + @config[:task][:vertical_margin]

      width = (duration * @day_width_px) - 2* @config[:task][:horizontal_margin]
      height = @config[:task][:height] - 2*@config[:task][:vertical_margin]

      rect x: x, y: y, width: width, height: height, rx: @config[:task][:rounding], fill: @config[:task][:fill],
           stroke: @config[:task][:line], stroke_width: @config[:task][:line_weight]
      text name, x: x + width/2, y: y + height/2, font_size: @config[:task][:font_size],
           fill: @config[:task][:font_color]
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
           fill: @config[:milestone][:fill],
           stroke: @config[:milestone][:line],
           stroke_width: @config[:milestone][:line_weight],
           transform: "rotate (45 #{milestone_center_x} #{milestone_center_y})",
           rx: @config[:milestone][:rounding]

      text name, x: x + milestone_height, y: milestone_center_y, font_size: @config[:task][:font_size],
           fill: @config[:milestone][:font_color], text_anchor: 'start'
    end

    # TODO: Only add tasks and sections and then draw them all during the render stage.
    # TODO: This will fix sections being drawn on top of gridlines.
  end
end