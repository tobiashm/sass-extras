require_relative "spec_helper"

describe Sass::Extras::YUV::Color do
  before do
    @color = Sass::Script::Color.new [255, 255, 255]
  end

  describe "a beginning" do
    it "should just be numbers" do
      @color.rgb.each do |c|
        c.class.must_equal Integer
      end
      @color.hue do |c|
        c.class.must_equal Integer
      end
      @color.yuv.each do |c|
        c.class.must_equal Float
      end
    end

    it "must have solid aplha chanel" do
      @color.alpha.must_equal 1
      @color.yuva.last.must_equal 1
    end
  end

  describe "convertion to yuv" do
    it "must be exected r g b value" do
      @color.rgb.map { |k| k / 255.0 }.must_equal [1, 1, 1]
    end

    it "must respond apropriate" do
      @color.yuv.must_equal [1, 0, 0]
    end

    it "has aproximated brightness" do
      color = Sass::Script::Color.new [0x19, 0x19, 0x19]
      color.inspect.must_equal "#191919"
      y, u, v = color.yuv
      y.must_be_within_delta 0.1, 0.002
      u.must_be_within_delta 0
      v.must_be_within_delta 0
    end
  end

  describe "usage in render" do
    it "can define color" do
      <<CSS.must_equal render(<<SASS)
a {
  b: #1a1a1a; }
CSS
a {
  b: yuv(10%, 0, 0); }
SASS
    end

    it "converts nicely" do
      <<CSS.must_equal render(<<SASS)
a {
  b: #1a1a1a; }
CSS
a {
  b: set-brightness(#ffffff, 10%); }
SASS
    end

    it "reduces brightness" do
      <<CSS.must_equal render(<<SASS)
a {
  b: #e6e6e6; }
CSS
a {
  b: reduce-brightness(#ffffff, 10%); }
SASS
    end
  end

  def render(sass)
    Sass::Engine.new(sass, syntax: :scss).render
  end
end
