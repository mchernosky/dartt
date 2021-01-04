module Dartt
  class Milestone
    attr_reader :name

    def initialize(name, date)
      if date.is_a?(Hash)
        if date.include?(:start_of)
          @milestone_on_start_of_day = true
          date = date[:start_of]
        end
      end
      @milestone = Task.new(name).start(date).duration(1)
    end

    def ==(other)
      name == other.name and date == other.date
    end

    def name
      @milestone.name
    end

    def date
      if @milestone_on_start_of_day.nil?
        @milestone.start
      else
        # Set the milestone date to the previous day, so that it will show at the start of the requested day.
        @milestone.start - 1
      end
    end

    def start
      date
    end

    def end
      date
    end
  end
end