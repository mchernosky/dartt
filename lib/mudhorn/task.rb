module Mudhorn
  class Task
    attr_reader :name, :duration

    def initialize (name)
      @name = name
      self
    end

    def start(date = nil)
      if date.nil?
        # No date has been supplied, this is the "get" operation.
        @start
      else
        # A date has been provided, this is the "set" operation.
        @start = date
        self
      end
    end

    def set_duration(days)
      @duration = days
      self
    end

    def get_end
      @start + (@duration - 1)
    end

    def set_end(date)
      @end = date
      self
    end

    def get_start
      @end - (@duration - 1)
    end
  end
end