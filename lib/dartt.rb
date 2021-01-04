require "dartt/version"
require 'dartt/graph'
require 'dartt/task'
require 'dartt/milestone'

module Dartt
  class TaskOverconstrained < StandardError
    def initialize(name, start_date, end_date, duration)
      @name = name
      @start_date = start_date
      @end_date = end_date
      @duration = duration
    end

    def message
      super
      "Task #{@name} is over constrained (start: #{start_date}, end: #{@end_date}, duration: #{duration} )"
    end
  end
end
