module Mudhorn
  class Task
    attr_reader :name

    def initialize (name)
      @name = name
      self
    end

    def start(date = nil)
      if date.nil?
        get_start
      else
        set_start(date)
      end
    end

    def duration(days = nil)
      if days.nil?
        get_duration
      else
        set_duration(days)
        self
      end
    end

    def get_end
      @start + (@duration - 1)
    end

    def set_end(date)
      @end = date
      self
    end

    private

    def set_duration(days)
      @duration = days
    end

    def get_duration
      @duration
    end

    def set_start(date)
      @start = date
      self
    end

    def get_start
      if @start.nil?
        # No start date has been set, compute from the end date.
        @end - (@duration - 1)
      else
        @start
      end
    end

  end
end