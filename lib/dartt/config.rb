require 'pp'

module Dartt

  module Config
    def build
      {
          :width => 1920
      }
    end

    module_function :build
  end

end