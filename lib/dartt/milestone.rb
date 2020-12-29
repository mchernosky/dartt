module Dartt
  class Milestone
    attr_reader :name

    def initialize(name, date)
      @name = name
      @milestone = Task.new(name).start(date).duration(1)
    end

    def date
      @milestone.start
    end
  end
end