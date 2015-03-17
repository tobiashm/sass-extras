module Sass
  module Extras
    module Contrast
      BRIGHTNESS_COEFS = [0.299, 0.587, 0.114]
      LUMINANCE_COEFS = [0.2126, 0.7152, 0.0722]

      module Color
        def diff(other)
          # W3C
          Utils.sum(Utils.abs(rgb, other.rgb))
        end

        def diff_alt(other)
          # 3D - Sqrt(dr^2+dg^2+db^2)
          Math.sqrt(Utils.sum(Utils.sq(Utils.abs(rgb, other.rgb))))
        end

        def brightness
          # W3C; Rec. 601 luma
          Utils.sum(Utils.mul(rgb, BRIGHTNESS_COEFS))
        end

        def brightness_alt
          # http://alienryderflex.com/hsp.html
          Math.sqrt(Utils.sum(Utils.mul(Utils.sq(rgb), [0.241, 0.691, 0.068])))
        end

        def luminance
          # http://www.w3.org/TR/WCAG20/#relativeluminancedef
          norm_rgb = rgb.map { |value| value.to_f / 255 }
          relative_luminance = norm_rgb.map { |v| v <= 0.03928 ? v / 12.92 : ((v + 0.055) / 1.055)**2.4 }
          Utils.sum(Utils.mul(relative_luminance, LUMINANCE_COEFS))
        end
      end

      module Functions
        def self.included(base)
          base.declare :contrast_color, [:color]
          base.declare :contrast_color, [:color, :seed_color]
          base.declare :contrast_color, [:color, :seed_color, :wcag20_level]
        end

        def contrast_color(color, seed_color = nil, wcag20_level = Sass::Script::String.new("aa"))
          seed_color ||= color
          assert_type color, :Color, :color
          assert_type seed_color, :Color, :seed_color
          assert_type wcag20_level, :String, :wcag20_level
          direction = color.brightness > 127 ? darken_method : lighten_method
          new_color = seed_color
          percentage = 0.0
          until conform(new_color, color, wcag20_level.value) || percentage > 100.0
            amount = Sass::Script::Number.new percentage, ['%']
            new_color = send(direction, seed_color, amount)
            percentage += 0.1
          end
          new_color
        end

        protected

        # http://www.w3.org/WAI/ER/WD-AERT/#color-contrast
        MIN_BRIGHT_DIFF = 125
        MIN_COLOR_DIFF = 500

        def conform(color1, color2, wcag20_level = "aa")
          bright_diff = (color1.brightness - color2.brightness).abs
          color_diff = color1.diff(color2)
          bright_diff >= MIN_BRIGHT_DIFF && color_diff >= MIN_COLOR_DIFF && wcag20_conform(color1, color2, wcag20_level)
        end

        # http://www.w3.org/TR/WCAG20/#visual-audio-contrast-contrast
        MIN_CONTRAST_RATE_AA = 4.5
        MIN_CONTRAST_RATE_AA_LARGE_TEXT = 3
        MIN_CONTRAST_RATE_AAA = 7
        MIN_CONTRAST_RATE_AAA_LARGE_TEXT = 4.5

        def min_contrast_rate(wcag20_level)
          case wcag20_level.to_s.downcase
          when "aaa_large"
            MIN_CONTRAST_RATE_AAA_LARGE_TEXT
          when "aaa"
            MIN_CONTRAST_RATE_AAA
          when "aa_large"
            MIN_CONTRAST_RATE_AA_LARGE_TEXT
          else
            MIN_CONTRAST_RATE_AA
          end
        end

        def wcag20_conform(color1, color2, wcag20_level = "aa")
          contrast_ratio(color1, color2) >= min_contrast_rate(wcag20_level)
        end

        def contrast_ratio(color1, color2)
          assert_type color1, :Color
          assert_type color2, :Color
          l1, l2 = color1.luminance, color2.luminance
          l2, l1 = l1, l2 if l2 > l1
          (l1 + 0.05) / (l2 + 0.05)
        end

        private

        def lighten_method
          respond_to?(:add_brightness) ? :add_brightness : :lighten
        end

        def darken_method
          respond_to?(:detract_brightness) ? :detract_brightness : :darken
        end
      end

      module Utils
        def self.abs(array, other)
          array.zip(other).map { |x, y| (x.to_f - y.to_f).abs }
        end

        def self.mul(array, other)
          array.zip(other).map { |x, y| x.to_f * y.to_f }
        end

        def self.sum(array)
          array.inject(0) { |sum, value| sum + value.to_f }
        end

        def self.sq(array)
          array.map { |e| e**2 }
        end
      end
    end
  end
end
