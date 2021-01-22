module Dartt
  class Milestone
    attr_reader :name

    def initialize(name, date=nil, start_of: nil, tag: nil)
      @milestone = Task.new(name).start(date).duration(1)
      unless tag.nil?
        @milestone = @milestone.tag(tag)
      end
    end

    def ==(other)
      name == other.name and date == other.date
    end

    def name
      @milestone.name
    end

    def date
      @milestone.start
    end

    def start
      date
    end

    def end
      date
    end

    def tag
      @milestone.tag
    end
  end
end