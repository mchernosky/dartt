module Mudhorn
  class Task
    attr_reader :name, :start, :duration

    def initialize (name)
      @name = name
      self
    end

    def set_start(date)
      @start = date
      self
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