require "dartt/version"
require 'dartt/chart'
require 'dartt/graph'
require 'dartt/task'
require 'dartt/milestone'
require 'dartt/config'

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

  class TaskInvalid < StandardError
    def initialize(task, message)
      @task = task
      @message = message
    end

    def message
      super
      "Task #{@task} is invalid: #{@message}"
    end
  end

   @@default_config = {
      :width => 1920,
      :height => 1080,
      :title => {
          :height => 108,
          :font_color => "#003470",
      },
      :section => {
          :width => 300,
          :margin => 20,
          :color_1 => '#FFFDA2',
          :color_1_opacity => 0.4,
          :color_2 => 'white',
          :color_2_opacity => 0.0,
      },
      :axis => {
          :height => 80,
          :week_height => 32,
          :fill_color => '#D7D7D7',
          :line_color => 'white',
          :line_weight => 2,
          :weekend_color => '#E0E0E0',
          :grid_line_color => '#C1C1C1',
      },
      :task => {
          :height => 40,
          :vertical_margin => 3,
          :horizontal_margin => 0,
          :rounding => 5,
          :font_size => 20,
          :font_color => "#003470",
          :fill => "#77B7FF",
          :line => "#0D57AB",
          :line_weight => 2,
      },
      :milestone => {
          :height => 40,
          :vertical_margin => 2,
          :rounding => 4,
          :font_size => 20,
          :font_color => "#003470",
          :fill => "#77B7FF",
          :line => "#0D57AB",
          :line_weight => 2,
      },
      :tags => {
          :done => {
              :font_color => "#505050",
              :fill => "#d5d5d5",
              :line => "#505050",
          },
      }
  }

  def self.default_config
    @@default_config
  end
end
