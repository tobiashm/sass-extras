require "chunky_png"

module Sass
  module Extras
    module InlineColorImage
      def self.included(base)
        base.declare :inline_color_image, [:color]
      end

      # Generates a data-url for a PNG created from the given color.
      # Can be used to set a alpha-transparent background for IE8<
      #
      # @example
      #   background: url(inline-color-image(rgba(102, 54, 32, 0.5)));
      def inline_color_image(color)
        assert_type color, :Color
        chunky_color = ChunkyPNG::Color.rgba(color.red, color.green, color.blue, (color.alpha * 255).round)
        Sass::Script::String.new(ChunkyPNG::Image.new(32, 32, chunky_color).to_data_url)
      end
    end
  end
end
