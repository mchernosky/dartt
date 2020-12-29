module Dartt
  class Milestone
    attr_reader :name

    def initialize(name, date)
      @milestone = Task.new(name).start(date).duration(1)
    end

    def name
      @milestone.name
    end

    def date
      @milestone.start
    end
  end
end