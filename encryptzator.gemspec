# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'encryptzator/version'

Gem::Specification.new do |spec|
  spec.name          = "encryptzator"
  spec.version       = Encryptzator::VERSION
  spec.authors       = ["Marcos Santini"]
  spec.email         = ["cardosounicamp@gmail.com"]
  spec.summary       = %q{Short lib to encrypt and decrypt messages}
  spec.description   = %q{As a user I'd like to have an way to encrypt and decrypt my messages secretly}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
