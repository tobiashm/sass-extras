require "base64"
require "rack"

module Sass
  module Extras
    module SvgGradients
      def self.included(base)
        base.declare :linear_gradient_image_data_url, [:color, :height]
        base.declare :radial_gradient_image_data_url, [:color, :height]
      end

      def radial_gradient_image_data_url(color = Sass::Script::Color.new([0, 0, 0]), height = Sass::Script::Number.new(5))
        assert_type color, :Color
        assert_type height, :Number
        svg_data_url(<<-SVG)
          <svg xmlns="http://www.w3.org/2000/svg">
            <defs>
              <radialGradient id="gradient">
                <stop offset="50%" stop-color="#{svg_color(color)}" stop-opacity="0.2"/>
                <stop offset="100%" stop-color="#{svg_color(color)}" stop-opacity="0"/>
              </radialGradient>
            </defs>
            <rect width="100%" height="#{Sass::Script::Number.new(2).times(height)}" y="-#{height}" fill="url(#gradient)"></rect>
          </svg>
        SVG
      end

      def linear_gradient_image_data_url(color = Sass::Script::Color.new([255, 255, 255]), height = Sass::Script::Number.new(100, ['%']))
        assert_type color, :Color
        assert_type height, :Number
        svg_data_url(<<-SVG)
          <svg xmlns="http://www.w3.org/2000/svg">
            <defs>
              <linearGradient id="gradient" x1="0" x2="0" y1="0" y2="100%">
                <stop offset="25%" stop-color="#{svg_color(color)}" stop-opacity="1"/>
                <stop offset="100%" stop-color="#{svg_color(color)}" stop-opacity="0"/>
              </linearGradient>
            </defs>
            <rect width="100%" height="#{height}" fill="url(#gradient)"></rect>
          </svg>
        SVG
      end

      protected

      def svg_color(color)
        "rgb(#{color.rgb.join(',')})"
      end

      def svg_data_url(svg)
        base64 = Base64.encode64(svg).gsub(/\s+/, "")
        Sass::Script::String.new("url(data:image/svg+xml;base64,#{Rack::Utils.escape(base64)})")
      end
    end
  end
end
