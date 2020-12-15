module Mudhorn
  class Task
    attr_reader :name

    def self.exclude(date)

    end

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

    def end(date = nil)
      if date.nil?
        get_end
      else
        set_end(date)
        self
      end
    end

    private

    def set_end(date)
      if @start.nil? or @duration.nil?
        @end = date
      else
        raise TaskOverconstrained.new(@name, @start, date, @duration)
      end
    end

    def get_end
      end_date = @start
      (@duration - 1).times do
        end_date = get_next_included_date(end_date)
      end
      end_date
    end

    def set_duration(days)
      if @start.nil? or @end.nil?
        @duration = days
      else
        # Both the start and the end are already defined -- this is an error.
        raise TaskOverconstrained.new(@name, @start, @end, days)
      end
    end

    def get_duration
      if @duration.nil?
        duration = 0
        (@start..@end).each do |day|
          unless excluded?(day)
            duration +=1
          end
        end
        duration
      else
        @duration
      end
    end

    def set_start(date)
      if @duration.nil? or @end.nil?
        @start = date
      else
        raise TaskOverconstrained.new(@name, date, @end, @duration)
      end
      self
    end

    def get_start
      if @start.nil?
        # No start date has been set, compute from the end date.
        start_date = @end
        (@duration-1).times do
          start_date = get_previous_included_date(start_date)
        end
        start_date
      else
        @start
      end
    end

    def excluded?(day)
      day.saturday? or day.sunday?
    end

    def get_previous_included_date(date)
      loop do
        date -= 1
        break unless excluded?(date)
      end
      date
    end

    def get_next_included_date(date)
      loop do
        date += 1
        break unless excluded?(date)
      end
      date
    end

  end
end