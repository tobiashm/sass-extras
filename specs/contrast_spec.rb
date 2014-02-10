require_relative "spec_helper"

describe Sass::Extras::Contrast do
  it "calculates brightness" do
    white = Sass::Script::Color.new [255, 255, 255]
    white.brightness.must_be_within_delta 255.0
    grey = Sass::Script::Color.new [0xe5, 0xe5, 0xe5]
    grey.brightness.must_be_within_delta 0.9*255, 1.0
  end

  it "should generate colors with enough contrast" do
    data = File.read(__FILE__).split("__END__").last
    css = Sass::Engine.new(data, :syntax => :scss).to_css
    rules = css.gsub(/\s+/, ' ').gsub(/\} a/, '}\na').split('\n')
    rules.each { |rule| rule.must_match(/a \{ color: (#?\w+); background: \1; \}/) }
  end
end

__END__
a {
  color: contrast-color(white, #ff0000);
  background: #ee0000;
  }

a {
  color: contrast-color(rgb(127,127,127));
  background: white;
  }

a {
  color: contrast-color(rgb(128,128,128));
  background: black;
  }

a {
  color: contrast-color(white);
  background: #585858;
  }

a {
  color: contrast-color(black);
  background: #a7a7a7;
  }

a {
  color: contrast-color(red);
  background: #ffaeb2;
  }

a {
  color: contrast-color(green);
  background: #b3ffb3;
  }

a {
  color: contrast-color(blue);
  background: #e1eeff;
  }

a {
  color: contrast-color(#123456);
  background: #b8dcfc;
  }
