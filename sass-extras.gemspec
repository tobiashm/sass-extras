# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sass/extras/version'

Gem::Specification.new do |spec|
  spec.name          = "sass-extras"
  spec.version       = Sass::Extras::VERSION
  spec.authors       = ["Tobias Haagen Michaelsen"]
  spec.email         = ["tobias.michaelsen@gmail.com"]
  spec.summary       = %q{A collection of SASS extensions.}
  spec.description   = %q{A collection of SASS functions and helper methods.}
  spec.homepage      = "https://github.com/tobiashm/sass-extras"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "sass"
  spec.add_dependency "chunky_png"
  spec.add_dependency "rack"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
end
