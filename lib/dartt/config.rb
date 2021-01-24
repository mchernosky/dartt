require 'pp'

module Dartt

  module Config

    def build(custom_config=nil)
      if custom_config.nil?
        @@default_config
      else
        @@default_config.merge(custom_config)
      end
    end

    module_function :build

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
  end

end