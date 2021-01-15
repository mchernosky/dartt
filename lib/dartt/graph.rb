require 'victor'
require 'pp'

module Dartt

  class Graph

    attr_reader :title, :elements

    def initialize (title, start_date, end_date, config:Dartt.default_config)
      @title = title
      # TODO: The end_date should be included on the chart.
      @total_days = (end_date - start_date).to_i
      @start_date = start_date
      @end_date = end_date
      @config = config

      @day_width = 100.0/@total_days
      @sections = []
      @elements = []

      @svg = Victor::SVG.new viewBox: "0 0 #{@config[:width]} #{@config[:height]}", font_family: 'arial', font_size: 40, fill: "white", text_anchor:"middle", dominant_baseline:"middle"

      # Draw the title.
      @svg.text @title, x:@config[:width]/2, y: @config[:title][:height]/2, fill: @config[:title][:font_color]

    end

    def add(element)
      @elements << element
    end

    def add_section(name, start_row, end_row)
      @sections << {:name => name, :start_row => start_row, :end_row => end_row}
    end

    def render
      @day_width_px = (@config[:width] - get_section_width).to_f / @total_days

      # Grid lines
      x_position = get_section_width
      (@start_date..@end_date).each do |day|
        if day.saturday? || day.sunday? and not day == @end_date
          @svg.rect x:x_position, y:@config[:title][:height], width:@day_width_px, height:@config[:height] - @config[:title][:height] - @config[:axis][:height], fill:@config[:axis][:weekend_color]
        end
        @svg.line x1:x_position, y1:@config[:title][:height], x2:x_position, y2:@config[:height] - @config[:axis][:height], stroke:@config[:axis][:grid_line_color]
        x_position += @day_width_px
      end

      #Sections
      @sections.each_with_index { |s, i| draw_section(i, s[:name], s[:start_row], s[:end_row]) }

      # Draw months.
      current_month = @start_date.month
      current_month_start_day = @start_date
      (@start_date..@end_date).each do |day|
        if day.month != current_month || day == @end_date
          # This is the start of a new month. Draw the previous month.
          x = get_section_width + ((current_month_start_day - @start_date).to_i) * @day_width_px
          y = @config[:height] - @config[:axis][:height] + @config[:axis][:week_height]
          width = (day - current_month_start_day).to_i * @day_width_px
          height = @config[:axis][:height] - @config[:axis][:week_height]
          @svg.rect x: x, y: y, width: width, height: height, stroke: @config[:axis][:line_color], fill: @config[:axis][:fill_color], stroke_width: @config[:axis][:line_weight]
          @svg.text Date::ABBR_MONTHNAMES[current_month_start_day.month], x: x + width/2, y: y + height/2, font_size: @config[:task][:font_size],
               fill: @config[:task][:font_color]
          current_month = day.month
          current_month_start_day = day
        end
      end

      # Draw weeks.
      current_week_start_day = @start_date
      (@start_date..@end_date).each do |day|
        if day.monday? || (day == @end_date)
          # This is the start of a new week. Draw the previous week.
          x = get_section_width + ((current_week_start_day - @start_date).to_i) * @day_width_px
          y = @config[:height] - @config[:axis][:height]
          width = (day - current_week_start_day).to_i * @day_width_px
          height = @config[:axis][:week_height]
          @svg.rect x: x, y: y, width: width, height: height, stroke: @config[:axis][:line_color], fill: @config[:axis][:fill_color], stroke_width: @config[:axis][:line_weight]
          @svg.text current_week_start_day.day, x: x+5, y: y + height/2, font_size: @config[:task][:font_size],
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

      # Add a script that shifts the task text to outside the bar if it doesn't fit.
      @svg.script type: "text/javascript" do
        @svg._ %[
          const tasks = document.getElementsByClassName('task');
          for (i = 0; i < tasks.length; i++) {
            const bar = tasks[i].children[0];
            var text = tasks[i].children[1];
            const bar_length = parseFloat(bar.getAttribute("width"));
            const text_length = text.getComputedTextLength();
            if (text_length > bar_length) {
              const text_x_position = parseFloat(text.getAttribute("x"));
              text.setAttribute("text-anchor", "start");
              text.setAttribute("x", text_x_position + (bar_length/2) + 8);
            }
          }
        ]
      end

      @svg.render
    end

    private

    def get_section_width
      if @sections.empty?
        0
      else
        @config[:section][:width]
      end
    end

    def draw_section(index, name, start_row, end_row)
      y = @config[:title][:height] + start_row*@config[:task][:height]
      height = (end_row-start_row+1)*@config[:task][:height]
      fill = @config[:section][:color_1]
      opacity = @config[:section][:color_1_opacity]
      if index % 2 == 1
        fill = @config[:section][:color_2]
        opacity = @config[:section][:color_2_opacity]
      end
      @svg.rect x: "0%", y: y, width: "100%", height: height, fill: fill, fill_opacity: opacity
      @svg.text name, x:@config[:section][:margin], y: y+height/2, text_anchor:'start', fill:'black', font_size: 24
    end

    def draw_task(name, row, start_day, duration)
      task_horizontal_margin_percent = @config[:task][:horizontal_margin].to_f/@config[:width]*100

      x = get_section_width + ((start_day - 1) * @day_width_px) + @config[:task][:horizontal_margin]
      y = @config[:title][:height]
      y += (row * @config[:task][:height]) + @config[:task][:vertical_margin]

      width = (duration * @day_width_px) - 2* @config[:task][:horizontal_margin]
      height = @config[:task][:height] - 2*@config[:task][:vertical_margin]

      @svg.g class: "task" do
        @svg.rect x: x, y: y, width: width, height: height, rx: @config[:task][:rounding], fill: @config[:task][:fill],
             stroke: @config[:task][:line], stroke_width: @config[:task][:line_weight]
        @svg.text name, x: x + width/2, y: y + height/2 + 1, font_size: @config[:task][:font_size],
             fill: @config[:task][:font_color]
      end
    end

    def draw_milestone(name, row, day)
      milestone_height = @config[:milestone][:height] - 2*@config[:milestone][:vertical_margin]
      milestone_side = Math.sqrt((milestone_height*milestone_height)/2)

      section_width_px = get_section_width
      title_height_px = @config[:title][:height]

      milestone_center_x = section_width_px + day * @day_width_px
      milestone_center_y = title_height_px + ((row * @config[:task][:height]) + (@config[:task][:height]/2))
      x = milestone_center_x - milestone_side/2
      y = milestone_center_y - milestone_side/2

      # Draw the milestone and rotate it to form a diamond.
      @svg.rect x:x, y:y, width:milestone_side, height:milestone_side,
           fill: @config[:milestone][:fill],
           stroke: @config[:milestone][:line],
           stroke_width: @config[:milestone][:line_weight],
           transform: "rotate (45 #{milestone_center_x} #{milestone_center_y})",
           rx: @config[:milestone][:rounding]

      @svg.text name, x: x + milestone_height, y: milestone_center_y + 1, font_size: @config[:task][:font_size],
           fill: @config[:milestone][:font_color], text_anchor: 'start'
    end
  end
end