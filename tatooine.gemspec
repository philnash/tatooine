# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tatooine/version'

Gem::Specification.new do |spec|
  spec.name          = "tatooine"
  spec.version       = Tatooine::VERSION
  spec.authors       = ["Phil Nash"]
  spec.email         = ["philnash@gmail.com"]
  spec.summary       = %q{A Ruby interface to SWAPI (the Star Wars API).}
  spec.description   = %q{A Ruby interface to SWAPI (the Star Wars API). http://swapi.co/}
  spec.homepage      = "https://github.com/philnash/tatooine"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 1.9.2'

  spec.add_dependency "faraday", "~> 0.9.0"
  spec.add_dependency "faraday_middleware"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "vcr", "~> 2.9.3"
  spec.add_development_dependency "rspec", "~> 3.5"
  spec.add_development_dependency "webmock", "~> 1.20.0"
  spec.add_development_dependency "simplecov"
end
