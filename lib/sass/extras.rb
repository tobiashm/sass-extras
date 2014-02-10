require "sass"
require "sass/extras/version"
require "sass/extras/contrast"
require "sass/extras/inline_color_image"
require "sass/extras/svg_gradients"
require "sass/extras/yuv"

module Sass
  module Script
    class Color
      include Sass::Extras::Contrast::Color
      include Sass::Extras::YUV::Color
    end

    module Functions
      include Sass::Extras::Contrast::Functions
      include Sass::Extras::InlineColorImage
      include Sass::Extras::SvgGradients
      include Sass::Extras::YUV::Functions
    end
  end
end
