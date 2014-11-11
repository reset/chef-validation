# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chef/validation/version'

Gem::Specification.new do |spec|
  spec.name          = "chef-validation"
  spec.version       = Chef::Validation::VERSION
  spec.authors       = ["Jamie Winsor"]
  spec.email         = ["jamie@vialstudios.com"]
  spec.summary       = %q{Perform validation on your node's attributes from a Cookbook's attribute metadata definitions.}
  spec.description   = %q{Perform validation on your node's attributes from a Cookbook's attribute metadata definitions.}
  spec.homepage      = "https://github.com/reset/chef-validation"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "chef", ">= 11.0.0"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
