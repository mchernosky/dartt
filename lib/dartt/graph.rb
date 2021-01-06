require 'victor'
require 'pp'

module Dartt

  class Chart
    attr_reader :name
    def initialize (name, start_date, end_date)
      @sections = []
      @graph = Graph.new(name, start_date, end_date)
    end

    def name
      @graph.title
    end

    def task (name, start: nil, days: nil, before: nil, after: nil)
      new_task = Task.new(name)
      unless start.nil?
        new_task = new_task.start(start)
      end
      unless days.nil?
        new_task = new_task.duration(days)
      end
      unless before.nil?
        new_task = new_task.end(before.start - 1)
      end
      unless after.nil?
        new_task = new_task.start(after.end + 1)
      end
      @graph.add(new_task)
      new_task
    end

    def milestone (name, date)
      if date.is_a?(Hash)
        if date.include?(:after)
          date = date[:after].end
        end
      end
      new_milestone = Milestone.new(name, date)
      @graph.add(new_milestone)
      new_milestone
    end

    def section (title)
      @sections << {:title => title, :start_index => @graph.elements.length}
    end

    def include?(obj)
      @graph.elements.include?(obj)
    end

    def render
      # Add all the sections.
      @sections.each_with_index do |s, i|
        end_index = @graph.elements.length - 1
        unless @sections[i+1].nil?
          end_index = @sections[i+1][:start_index] - 1
        end
        @graph.add_section(s[:title], s[:start_index], end_index)
      end
      @graph.render
    end
  end

  def chart(name, start_date = Date.new(2021, 1, 4), end_date = Date.new(2021, 1, 14), &block)
    c = Chart.new(name, start_date, end_date)
    if block_given?
      c.instance_eval(&block)
    end
    c
  end

  module_function :chart

  class Graph

    attr_reader :title, :elements
    @@default_config = {
        :width => 1920,
        :height => 1080,
        :title => {
            :height => 108,
            :font_color => "#003470",
        },
        :section => {
            :width => 300,
            :margin => 20,
            :color_1 => '#FFFDA2',
            :color2 => 'white',
        },
        :axis_height => 80,
        :week_height => 32,
        :axis_fill_color => '#D7D7D7',
        :axis_line_color => 'white',
        :axis_line_weight => 2,
        :weekend_color => '#E0E0E0',
        :grid_line_color => '#C1C1C1',
        :task => {
            :height => 40,
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
            :height => 40,
            :vertical_margin => 2,
            :rounding => 4,
            :font_size => 20,
            :font_color => "#003470",
            :fill => "#77B7FF",
            :line => "#0D57AB",
            :line_weight => 2,
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
      @elements = []

      @day_width_px = (@config[:width] - @config[:section][:width]).to_f / @total_days

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

      #Sections
      @sections.each_with_index { |s, i| draw_section(i, s[:name], s[:start_row], s[:end_row]) }

      # Grid lines
      x_position = @config[:section][:width]
      (@start_date..@end_date).each do |day|
        if day.saturday? || day.sunday? and not day == @end_date
          @svg.rect x:x_position, y:@config[:title][:height], width:@day_width_px, height:@config[:height] - @config[:title][:height] - @config[:axis_height], fill:@config[:weekend_color]
        end
        @svg.line x1:x_position, y1:@config[:title][:height], x2:x_position, y2:@config[:height] - @config[:axis_height], stroke:@config[:grid_line_color]
        x_position += @day_width_px
      end

      # Draw months.
      current_month = @start_date.month
      current_month_start_day = @start_date
      (@start_date..@end_date).each do |day|
        if day.month != current_month || day == @end_date
          # This is the start of a new month. Draw the previous month.
          x = @config[:section][:width] + ((current_month_start_day - @start_date).to_i) * @day_width_px
          y = @config[:height] - @config[:axis_height] + @config[:week_height]
          width = (day - current_month_start_day).to_i * @day_width_px
          height = @config[:axis_height] - @config[:week_height]
          @svg.rect x: x, y: y, width: width, height: height, stroke: @config[:axis_line_color], fill: @config[:axis_fill_color], stroke_width: @config[:axis_line_weight]
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
          x = @config[:section][:width] + ((current_week_start_day - @start_date).to_i) * @day_width_px
          y = @config[:height] - @config[:axis_height]
          width = (day - current_week_start_day).to_i * @day_width_px
          height = @config[:week_height]
          @svg.rect x: x, y: y, width: width, height: height, stroke: @config[:axis_line_color], fill: @config[:axis_fill_color], stroke_width: @config[:axis_line_weight]
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

    def draw_section(index, name, start_row, end_row)
      y = @config[:title][:height] + start_row*@config[:task][:height]
      height = (end_row-start_row+1)*@config[:task][:height]
      fill = @config[:section][:color_1]
      if index % 2 == 1
        fill = @config[:section][:color_2]
      end
      @svg.rect x: "0%", y: y, width: "100%", height: height, fill: fill
      @svg.text name, x:@config[:section][:margin], y: y+height/2, text_anchor:'start', fill:'black', font_size: 24
    end

    def draw_task(name, row, start_day, duration)
      task_horizontal_margin_percent = @config[:task][:horizontal_margin].to_f/@config[:width]*100

      x = @config[:section][:width] + ((start_day - 1) * @day_width_px) + @config[:task][:horizontal_margin]
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

      section_width_px = @config[:section][:width]
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