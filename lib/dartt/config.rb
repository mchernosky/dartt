require 'pp'

module Dartt

  Config = Struct.new(:font) do
    def initialize(font: Font.new(20))
      super (font)
    end
  end
  Font = Struct.new(:size)

  class CustomConfigBuilder
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