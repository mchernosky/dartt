
module Dartt
  class Config
    def initialize (default_config=nil)
      if default_config.nil?
        @font_size = 20
      else
        @font_size = default_config[:font_size]
      end
    end
    def font_size
      @font_size
    end
    def font
      def size
        20
      end
    end
  end
end