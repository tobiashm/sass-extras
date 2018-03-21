require_relative "spec_helper"

describe Sass::Extras::SvgDataUrls do
  describe "circle_image_data_url" do
    it "renders to a data-url" do
      render(unindent(<<-SCSS)).must_equal unindent(<<-CSS)
        a {
          b: circle_image_data_url(); }
      SCSS
        a {
          b: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg"><circle cx="10" cy="10" r="10" fill="rgb(0,0,0)"/></svg>'); }
      CSS
    end
  end

  describe "radial_gradient_image_data_url" do
    it "renders to a data-url" do
      render(unindent(<<-SCSS)).must_equal unindent(<<-CSS)
        a {
          b: radial_gradient_image_data_url(); }
      SCSS
        a {
          b: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg"><defs><radialGradient id="gradient"><stop offset="50%" stop-color="rgb(0,0,0)" stop-opacity="0.2"/><stop offset="100%" stop-color="rgb(0,0,0)" stop-opacity="0"/></radialGradient></defs><rect width="100%" height="10" y="-5" fill="url(#gradient)"></rect></svg>'); }
      CSS
    end
  end
end
