# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'velocify/version'

Gem::Specification.new do |spec|
  spec.name          = "velocify"
  spec.version       = Velocify::VERSION
  spec.authors       = ["Daniel Dyba", "Jason Roberts"]
  spec.email         = ["daniel.dyba@gmail.com", "jrob00@gmail.com"]

  spec.summary       = %q{A library to communicate with Velocify's API.}
  spec.description   = %q{A library to communicate with Velocify's API.}
  spec.homepage      = "http://github.com/pennymac/velocify"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "savon", "~> 2.10"
  spec.add_dependency "activesupport", "~> 4.2"
  spec.add_dependency "dotenv", "~> 2.0"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "yard", "~> 0.8.7.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.8"
end
