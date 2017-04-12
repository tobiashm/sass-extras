require "matrix"

module Sass
  module Extras
    module XYZ
      WHITE_REFERENCE = [95.05, 100.00, 108.90].freeze # Illuminant D65

      RGB_TO_XYZ = Matrix[
        [0.4124, 0.3576, 0.1805],
        [0.2126, 0.7152, 0.0722],
        [0.0193, 0.1192, 0.9505]
      ]

      XYZ_TO_RGB = Matrix[
        [3.2406, -1.5372, -0.4986],
        [-0.9689, 1.8758, 0.0415],
        [0.0557, -0.2040, 1.0570]
      ]

      module Converter
        module_function

        def to_rgb(xyz)
          unlinearize_rgb(XYZ_TO_RGB * Vector[*xyz.map { |n| n / 100.0 }]).to_a
        end

        def to_xyz(rgb)
          (RGB_TO_XYZ * Vector[*linearize_rgb(rgb)]).to_a
        end

        def linearize_rgb(rgb)
          rgb
            .map { |c| c / 255.0 }
            .map { |c| c > 0.04045 ? ((c + 0.055) / 1.055)**2.4 : c / 12.92 }
            .map { |c| c * 100 }
        end

        def unlinearize_rgb(rgb)
          rgb
            .map { |c| c > 0.0031308 ? 1.055 * c**(1 / 2.4) - 0.055 : 12.92 * c }
            .map { |c| [0, [255, c * 255].min].max }
            .map(&:to_i)
        end
      end

      module Color
        def xyz
          Converter.to_xyz(rgb)
        end

        def xyza
          xyz + [alpha]
        end
      end

      module Functions
        def self.included(base)
          base.declare :xyz, [:x, :y, :z]
          base.declare :xyza, [:x, :y, :z, :alpha]
        end

        # Creates a {Sass::Script::Color} object from X, Y, Z values.
        #
        # @param x [Number]
        #   A number between ? and ? inclusive
        # @param y [Number]
        #   A number between 0 and 100.0 inclusive
        # @param z [Number]
        #   A number between ? and ? inclusive
        # @return [Color]
        def xyz(x, y, z)
          assert_type x, :Number, :x
          assert_type y, :Number, :y
          assert_type z, :Number, :z

          rgb = Converter.to_rgb([x.value, y.value, z.value])

          Sass::Script::Color.new(rgb)
        end

        def xyza(x, y, z, a)
          assert_type a, :Number, :a
          xyz(x, y, z).with(alpha: a.value)
        end
      end
    end
  end
end
