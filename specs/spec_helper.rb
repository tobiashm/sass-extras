require "minitest/autorun"
require "sass/extras"

def unindent(s)
  s.gsub(/^#{s.scan(/^[ \t]+(?=\S)/).min}/, "")
end

def render(scss)
  Sass::Engine.new(scss, syntax: :scss).render
end
