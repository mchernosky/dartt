require 'dartt/graph'

module Dartt
  class Chart
    attr_reader :name
    def initialize (name, start_date, end_date, config: nil)
      @sections = []
      @graph = Graph.new(name, start_date, end_date, config: config)
    end

    def name
      @graph.title
    end

    def task (name, tag=nil, start: nil, end: nil, days: nil, before: nil, after: nil)

      # Parse the end argument separately into a different name because "end" is pretty tricky to use.
      end_date = binding.local_variable_get(:end)

      new_task = Task.new(name)
      unless start.nil?
        new_task = new_task.start(start)
      end
      unless end_date.nil?
        new_task = new_task.end(end_date)
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
      unless tag.nil?
        new_task = new_task.tag(tag)
      end
      @graph.add(new_task)
      new_task
    end

    def milestone (name, tag=nil, date: nil, after: nil, start_of: nil)
      unless after.nil?
        date = after.end
      end
      unless start_of.nil?
        date = start_of - 1
      end
      new_milestone = Milestone.new(name, date, tag: tag)
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

  def chart(name, start_date = Date.new(2021, 1, 4), end_date = Date.new(2021, 1, 14), config: nil, &block)
    c = Chart.new(name, start_date, end_date, config: config)
    if block_given?
      c.instance_eval(&block)
    end
    c
  end

  def svg (name, start_date, end_date, filename, config:nil, &block)
    c = chart(name, start_date, end_date, config: config, &block)
    File.open("#{filename}.svg", "w") { |f| f.write(c.render) }
  end

  module_function :chart, :svg

end