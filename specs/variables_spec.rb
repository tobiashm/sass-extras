require_relative "spec_helper"

describe Sass::Extras::Variables do
  describe "variable-get" do
    it "gets the value of a local variable" do
      render(unindent(<<-SCSS)).must_equal unindent(<<-CSS)
        a {
          $my-local-var: 42;
          b: variable-get(my-local-var); }
      SCSS
        a {
          b: 42; }
      CSS
    end

    it "also gets variables from the global scope" do
      render(unindent(<<-SCSS)).must_equal unindent(<<-CSS)
        $my-global-var: 42;
        a {
          b: variable-get(my-global-var); }
      SCSS
        a {
          b: 42; }
      CSS
    end
  end

  describe "global-variable-get" do
    it "get the value of a global variable" do
      render(unindent(<<-SCSS)).must_equal unindent(<<-CSS)
        $my-global-var: 42;
        a {
          b: global-variable-get(my-global-var); }
      SCSS
        a {
          b: 42; }
      CSS
    end
  end
end
