module Sass
  module Extras
    module YUV
      WR = 0.299
      WG = 0.587
      WB = 0.114
      W_SUM = WR + WG + WB # float arithmetics error => 0.9999999999999999
      U_MAX = 0.436
      V_MAX = 0.615

      module Color
        def yuv
          r, g, b = rgb.map { |k| k / 255.0 }
          y = r * WR + g * WG + b * WB
          y = 1.0 if y == W_SUM
          u = U_MAX*(b - y)/(1 - WB)
          v = V_MAX*(r - y)/(1 - WR)
          [y, Utils.restrict(u, -U_MAX..U_MAX), Utils.restrict(v, -V_MAX..V_MAX)]
        end

        def yuva
          yuv + [alpha]
        end
      end

      module Functions
        def self.included(base)
          base.declare :yuv, [:y, :u, :v]
          base.declare :yuva, [:y, :u, :v, :alpha]
          base.declare :set_brightness, [:color, :amount]
          base.declare :increase_brightness, [:color, :amount]
          base.declare :reduce_brightness, [:color, :amount]
          base.declare :add_brightness, [:color, :amount]
          base.declare :detract_brightness, [:color, :amount]
        end

        # Creates a {Color} object from luma (Y), and two chrominance (UV) values.
        #
        # @param y [Number]
        #   A number between 0 and 1.0 inclusive
        # @param u [Number]
        #   A number between -{U_MAX} and +{U_MAX} inclusive
        # @param v [Number]
        #   A number between -{V_MAX} and +{V_MAX} inclusive
        # @return [Color]
        def yuv(y, u, v)
          assert_type y, :Number, :y
          assert_type u, :Number, :u
          assert_type v, :Number, :v

          yv = y.value
          if y.numerator_units == ["%"] && y.denominator_units.empty?
            raise ArgumentError.new("Brightness (Y') value #{y} must be between 0% and 100% inclusive") unless (0..100).include?(y.value)
            yv = yv / 100.0
          else
            raise ArgumentError.new("Brightness (Y') value #{y} must be between 0 and 1.0 inclusive") unless (0..1.0).include?(y.value)
          end
          raise ArgumentError.new("Chrominance (U) value #{u} must be between -#{U_MAX} and #{U_MAX} inclusive") unless (-U_MAX..U_MAX).include?(u.value)
          raise ArgumentError.new("Chrominance (V) value #{v} must be between -#{V_MAX} and #{V_MAX} inclusive") unless (-V_MAX..V_MAX).include?(v.value)

          r = yv + v.value * (1 - WR)/(V_MAX)
          g = yv - u.value * (WB * (1 - WB))/(V_MAX * WG) - v.value * (WR * (1 - WR))/(V_MAX * WG)
          b = yv + u.value * (1 - WB)/U_MAX

          rgb = [r, g, b].map { |c| [0, [255, c * 255].min].max }
          Sass::Script::Color.new(rgb)
        end

        def yuva(y, u, v, a)
          assert_type a, :Number, :a
          yuv(y, u, v).with(:alpha => a.value)
        end

        # @param color [Color]
        # @param amount [Number] between 0 and 1.0, or 0% and 100%
        def set_brightness(color, amount)
          adjust_brightness(color, amount) { |c, y| c }
        end

        # @param color [Color]
        # @param amount [Number] between 0 and 1.0, or 0% and 100%
        def increase_brightness(color, amount)
          adjust_brightness(color, amount) { |c, y| [(1 + c) * y, 1.0].min }
        end

        # @param color [Color]
        # @param amount [Number] between 0 and 1.0, or 0% and 100%
        def reduce_brightness(color, amount)
          adjust_brightness(color, amount) { |c, y| [(1 - c) * y, 0.0].max }
        end

        # @param color [Color]
        # @param amount [Number] between 0 and 1.0, or 0% and 100%
        def add_brightness(color, amount)
          adjust_brightness(color, amount) { |c, y| [y + c, 1.0].min }
        end

        # @param color [Color]
        # @param amount [Number] between 0 and 1.0, or 0% and 100%
        def detract_brightness(color, amount)
          adjust_brightness(color, amount) { |c, y| [y - c, 0.0].max }
        end

        protected

        def adjust_brightness(color, amount)
          y, u, v, a = color.yuva.map { |x| Sass::Script::Number.new x }
          c = amount.value
          if amount.numerator_units == ["%"] && amount.denominator_units.empty?
            raise ArgumentError.new("Amount value #{amount} must be between 0% and 100% inclusive") unless (0..100).include?(c)
            c = c / 100.0
          else
            raise ArgumentError.new("Amount value #{amount} must be between 0 and 1.0 inclusive") unless (0..1.0).include?(c)
          end
          y = Sass::Script::Number.new yield(c, y.value)
          yuva(y, u, v, a)
        end
      end

      module Utils
        def self.restrict(value, range)
          [range.min, [value, range.max].min].max
        end
      end
    end
  end
end
