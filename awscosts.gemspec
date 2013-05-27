# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'awscosts/version'

Gem::Specification.new do |spec|
  spec.name          = "awscosts"
  spec.version       = AWSCosts::VERSION
  spec.authors       = ["Stephen Bartlett"]
  spec.email         = ["stephenb@rtlett.org"]
  spec.description   = %q{AWSCosts provides an easier way to calculate the costs of running your project in AWS}
  spec.summary       = %q{Programmatic access to AWS pricing}
  spec.homepage      = "https://github.com/srbartlett/awscosts"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "httparty", "~> 0.11.0"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'fakeweb'
end
