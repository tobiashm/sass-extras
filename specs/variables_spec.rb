require_relative "spec_helper"

describe Sass::Extras::Variables do
  describe "variable-get" do
    it "gets the value of a local variable" do
      unindent(<<-CSS).must_equal render(unindent(<<-SCSS))
        a {
          b: 42; }
      CSS
        a {
          $my-local-var: 42;
          b: variable-get(my-local-var); }
      SCSS
    end

    it "also gets variables from the global scope" do
      unindent(<<-CSS).must_equal render(unindent(<<-SCSS))
        a {
          b: 42; }
      CSS
        $my-global-var: 42;
        a {
          b: variable-get(my-global-var); }
      SCSS
    end
  end

  describe "global-variable-get" do
    it "get the value of a global variable" do
      unindent(<<-CSS).must_equal render(unindent(<<-SCSS))
        a {
          b: 42; }
      CSS
        $my-global-var: 42;
        a {
          b: global-variable-get(my-global-var); }
      SCSS
    end
  end

  def unindent(s)
    s.gsub(/^#{s.scan(/^[ \t]+(?=\S)/).min}/, "")
  end

  def render(scss)
    Sass::Engine.new(scss, syntax: :scss).render
  end
end
