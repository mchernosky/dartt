module Mudhorn
  class Task
    attr_reader :name

    def initialize (name)
      @name = name
      self
    end

    def start(date = nil)
      if date.nil?
        # No date has been supplied, this is the "get" operation.
        if @start.nil?
          # No start date has been set, compute from the end date.
          @end - (@duration - 1)
        else
          @start
        end
      else
        # A date has been provided, this is the "set" operation.
        @start = date
        self
      end
    end

    def duration(days = nil)
      if days.nil?
        # The "get" operation.
        @duration
      else
        # The "set" operation.
        @duration = days
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

  end
end