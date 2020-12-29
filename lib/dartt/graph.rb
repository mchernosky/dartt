require 'victor'
require 'pp'

module Dartt
  # TODO: Since we're using absolute coordinates now, do we have to subclass SVG?
  class Graph < Victor::SVG

    @@default_config = {
        :width => 1920,
        :height => 1080,
        :title_height => 108,
        :section_width => 300,
        :section_margin => 20,
        :section_first_color => '#EFFC7F',
        :section_second_color => 'white',
        :axis_height => 100,
        :week_height => 30,
        :weekend_color => '#D7D7D7',
        :grid_line_color => '#C1C1C1',
        :task => {
            :height => 50,
            :vertical_margin => 3,
            :horizontal_margin => 0,
            :rounding => 5,
            :font_size => 20,
            :font_color => "#003470",
            :fill => "#77B7FF",
            :line => "#0D57AB",
            :line_weight => 2,
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

    def initialize (title, start_date, end_date, config:@@default_config)
      @title = title
      # TODO: The end_date should be included on the chart.
      @total_days = (end_date - start_date).to_i
      @start_date = start_date
      @end_date = end_date
      @config = config

      @day_width = 100.0/@total_days
      @sections = []
      @tasks = []
      @elements = []

      @day_width_px = (@config[:width] - @config[:section_width]) / @total_days

          # Draw the parent SVG.
      super viewBox: "0 0 #{@config[:width]} #{@config[:height]}", font_family: 'arial', font_size: 40, fill: "white", text_anchor:"middle", dominant_baseline:"middle"

      # Draw the title.
      svg x:"0%", y:"0%", width:"100%", height:"10%" do
        text @title, x: "50%", y: "50%", fill: "black"
      end
    end

    def add(element)
      @elements << element
    end

    def add_section(name, start_row, end_row)
      @sections << {:name => name, :start_row => start_row, :end_row => end_row}
    end

    def render
      #Sections
      @sections.each_with_index { |s, i| draw_section(i, s[:name], s[:start_row], s[:end_row]) }

      # Grid lines
      x_position = @config[:section_width]
      (@start_date..@end_date).each do |day|
        if day.saturday? || day.sunday?
          rect x:x_position, y:@config[:title_height], width:@day_width_px, height:@config[:height] - @config[:title_height] - @config[:axis_height], fill:@config[:weekend_color]
        end
        line x1:x_position, y1:@config[:title_height], x2:x_position, y2:@config[:height] - @config[:axis_height], stroke:@config[:grid_line_color]
        x_position += @day_width_px
      end

      # Draw months.
      current_month = @start_date.month
      current_month_start_day = @start_date
      (@start_date..@end_date).each do |day|
        if day.month != current_month || day == @end_date
          # This is the start of a new month. Draw the previous month.
          x = @config[:section_width] + ((current_month_start_day - @start_date).to_i) * @day_width_px
          y = @config[:height] - @config[:axis_height] + @config[:week_height]
          width = (day - current_month_start_day).to_i * @day_width_px
          height = @config[:axis_height] - @config[:week_height]
          rect x: x, y: y, width: width, height: height, stroke: 'black'
          text Date::ABBR_MONTHNAMES[current_month_start_day.month], x: x + width/2, y: y + height/2, font_size: @config[:task][:font_size],
               fill: @config[:task][:font_color]
          current_month = day.month
          current_month_start_day = day
        end
      end

      # Draw weeks.
      current_week_start_day = @start_date
      (@start_date..@end_date).each do |day|
        if day.monday? || day == @end_date
          # This is the start of a new week. Draw the previous week.
          x = @config[:section_width] + ((current_week_start_day - @start_date).to_i) * @day_width_px
          y = @config[:height] - @config[:axis_height]
          width = (day - current_week_start_day).to_i * @day_width_px
          height = @config[:week_height]
          rect x: x, y: y, width: width, height: height, stroke: 'black'
          text current_week_start_day.day, x: x+5, y: y + height/2, font_size: @config[:task][:font_size],
               fill: @config[:task][:font_color], text_anchor: 'start'
          current_week_start_day = day
        end
      end

      #Tasks and milestones
      @elements.each_with_index do |e, i|
        if e.is_a?(Task)
          duration = (e.end - e.start).to_i + 1
          draw_task(e.name, i, (e.start - @start_date + 1).to_i, duration)
        elsif e.is_a?(Milestone)
          draw_milestone(e.name, i, (e.date - @start_date + 1).to_i)
        end
      end
      super
    end

    private

    def draw_section(index, name, start_row, end_row)
      y = @config[:title_height] + start_row*@config[:task][:height]
      height = (end_row-start_row+1)*@config[:task][:height]
      fill = @config[:section_first_color]
      if index % 2 == 1
        fill = @config[:section_second_color]
      end
      rect x: "0%", y: y, width: "100%", height: height, fill: fill
      text name, x:@config[:section_margin], y: y+height/2, text_anchor:'start', fill:'black', font_size: 24
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
  end
end