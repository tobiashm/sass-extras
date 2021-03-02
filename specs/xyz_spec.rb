require_relative "spec_helper"

describe Sass::Extras::XYZ::Color do
  describe "convertion to xyz" do
    it "handles white" do
      white = Sass::Script::Color.new [255, 255, 255]
      rounded(white.xyz).must_equal Sass::Extras::XYZ::WHITE_REFERENCE
    end

    it "handles black" do
      black = Sass::Script::Color.new [0, 0, 0]
      black.xyz.must_equal [0.0, 0.0, 0.0]
    end

    it "handles goldenrod" do
      goldenrod = Sass::Script::Color.new [0xda, 0xa5, 0x20]
      rounded(goldenrod.xyz, 4).must_equal [42.6293, 41.9200, 7.2111]
    end
  end

  describe "usage in render" do
    it "can define black" do
      render(<<SCSS).must_equal(<<CSS)
a {
  b: xyz(0, 0, 0); }
SCSS
a {
  b: black; }
CSS
    end

    it "can define white" do
      render(<<SCSS).must_equal(<<CSS)
a {
  b: xyz(#{Sass::Extras::XYZ::WHITE_REFERENCE.join(',')}); }
SCSS
a {
  b: white; }
CSS
    end

    it "can define color" do
      render(<<SCSS).must_equal(<<CSS)
a {
  b: xyz(42.632, 41.923, 7.213); }
SCSS
a {
  b: goldenrod; }
CSS
    end
  end

  def rounded(values, ndigits = 3)
    values.map { |c| c.round(ndigits) }
  end

  def render(scss)
    Sass::Engine.new(scss, syntax: :scss).render
  end
end
