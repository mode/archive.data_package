# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'data_package/version'

Gem::Specification.new do |spec|
  spec.name          = "data_package"
  spec.version       = DataPackage::VERSION
  spec.authors       = ["Mode Analytics"]
  spec.email         = ["support@modeanalytics.com"]
  spec.description   = %q{Library for reading and writing data packages}
  spec.summary       = %q{Provides a set of classes for reading and writing data packages}
  spec.homepage      = "http://www.modeanalytics.com/"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  # Runtime Dependencies
  spec.add_runtime_dependency 'rcsv'
  spec.add_runtime_dependency 'rubyzip'
  spec.add_runtime_dependency 'yajl-ruby'
  spec.add_runtime_dependency 'data_kit'
  spec.add_runtime_dependency 'active_support'

  # Development Dependencies
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "simplecov"
end
