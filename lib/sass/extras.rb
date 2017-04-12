require "sass"
require "sass/extras/version"
require "sass/extras/contrast"
require "sass/extras/inline_color_image"
require "sass/extras/svg_data_urls"
require "sass/extras/variables"
require "sass/extras/xyz"
require "sass/extras/yuv"

Sass::Script::Color.class_eval do
  include Sass::Extras::Contrast::Color
  include Sass::Extras::XYZ::Color
  include Sass::Extras::YUV::Color
end

Sass::Script::Functions.module_eval do
  include Sass::Extras::Contrast::Functions
  include Sass::Extras::InlineColorImage
  include Sass::Extras::SvgDataUrls
  include Sass::Extras::Variables
  include Sass::Extras::XYZ::Functions
  include Sass::Extras::YUV::Functions
end
