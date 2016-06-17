# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cerebro/version'

Gem::Specification.new do |spec|
  spec.name          = "cerebro"
  spec.version       = Cerebro::VERSION
  spec.authors       = ["James Wen"]
  spec.email         = ["jrw2175@columbia.edu"]

  spec.summary       = "A tool for searching through forks of github repos for information."
  spec.description   = "Description"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
