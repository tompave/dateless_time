# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dateless_time/version'
#require "dateless_time"

Gem::Specification.new do |spec|
  spec.name          = "dateless_time"
  spec.version       = DatelessTime::VERSION
  spec.author        = "Tommaso Pavese"
  spec.description   = %q{A class to handle dateless time values. DatelessTime objects are a lightweight alternative to Ruby's default Time class, and don't care about timezones and DST.}
  spec.summary       = %q{A class to handle dateless time values.}
  spec.homepage      = "https://github.com/tompave/dateless_time"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", '~> 10.0'

  spec.add_development_dependency 'minitest', '~> 5.3.1'
end
