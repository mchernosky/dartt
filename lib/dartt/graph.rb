require 'victor'

module Dartt
  # A class for calcluating the absolute position from a relative value
  # within an area defined by absolute position.
  class Area
    def initialize(x_start, y_start, x_end, y_end)
      @x_start = x_start
      @y_start = y_start
      @x_end = x_end
      @y_end = y_end
      puts "new area (#{x_start},#{y_start},#{x_end},#{y_end})"
    end

    def w(percent)
      @x_start + ((@x_end - @x_start)*percent).to_f/100
    end

    def h(percent)
      @y_start + (@y_end*percent)/100
    end
  end

  class Graph
    def initialize (width: 1920, height: 1080)
      @x_end = width
      @y_end = height

      title_height = 0.1
      axis_height = 0.1
      section_width = 0.2

      @svg = Victor::SVG.new viewBox: "0 0 #{@x_end} #{@y_end}", style: {background: '#ddd' }
      # Title
      title = Area.new(0, 0, @x_end, title_height*@y_end)
      @svg.rect x_start: title.w(0), y_start: title.h(0), x_end: title.w(100), y_end: title.h(100), rx: 5, fill: '#aaa'

      # Graph
      @svg.rect x_start: section_width*@x_end, y_start: title_height*@y_end, x_end: (1-section_width)*@x_end, y_end: (1-(title_height + axis_height))*@y_end, rx: 5, fill: '#999'
      # Axis
      @svg.rect x_start: section_width*@x_end, y_start: (1-axis_height)*@y_end, x_end: (1-section_width)*@x_end, y_end: axis_height*@y_end, rx: 5, fill: '#666'
    end
    def render
      @svg.render
    end

    def w(percent)
      @active_area.w(percent)
    end

    def area(x, y, width, height, &block)
      # Convert from percentage coordinates to absolute coordinates for
      # creating the area.
      x = x*@x_end/100
      width = width*@x_end/100
      y = y*@y_end/100
      height = height*@y_end/100
      @active_area = Area.new(x,y,width,height)
      if block_given?
        instance_eval(&block)
      end
    end
  end
end