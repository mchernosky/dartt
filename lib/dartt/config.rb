require 'pp'

module Dartt

  TopConfig = Struct.new(:font)
  Font = Struct.new(:size)

  class Config
    def initialize (default_config=nil)
      if default_config.nil?
        @config = TopConfig.new(Font.new(20))
      else
        @config = TopConfig.new(Font.new(default_config[:font][:size]))
      end
    end

    def font
      @config.font
    end
  end
end