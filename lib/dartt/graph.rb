require 'victor'

module Dartt
  # A class for calcluating the absolute position from a relative value
  # within an area defined by absolute position.
  # TODO: Fix the issues with width/height vs end position.
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
      @y_start + ((@y_end - @y_start)*percent).to_f/100
    end
  end

  class Graph
    def initialize (width: 1920, height: 1080)
      @x_end = width
      @y_end = height

      title_height = 10
      axis_height = 10
      section_width = 20

      @svg = Victor::SVG.new viewBox: "0 0 #{@x_end} #{@y_end}", style: {background: '#ddd' }
      # Title
      area(0, 0, 100, 10) do
        @svg.rect x: w(0), y: h(0), width: w(100), height: h(100), rx: 5, fill: '#aaa'
      end

      # Graph
      area(section_width, title_height, 100, 100 - axis_height) do
        @svg.rect x: w(0), y: h(0), width: w(100 - section_width), height: h(100), rx: 5, fill: '#999'
      end

      # Axis
      @svg.rect x_start: section_width*@x_end, y_start: (1-axis_height)*@y_end, x_end: (1-section_width)*@x_end, y_end: axis_height*@y_end, rx: 5, fill: '#666'
    end
    def render
      @svg.render
    end

    def w(percent)
      @active_area.w(percent)
    end

    def h(percent)
      @active_area.h(percent)
    end

    def area(x_start, y_start, x_end, y_end, &block)
      # Convert from percentage coordinates to absolute coordinates for
      # creating the area.
      x_start = x_start*@x_end/100
      x_end = x_end*@x_end/100
      y_start = y_start*@y_end/100
      y_end = y_end*@y_end/100
      @active_area = Area.new(x_start,y_start,x_end,y_end)
      if block_given?
        instance_eval(&block)
      end
    end
  end
end