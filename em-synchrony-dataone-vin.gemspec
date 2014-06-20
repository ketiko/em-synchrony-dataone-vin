# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'em-synchrony/dataone-vin/version'

Gem::Specification.new do |spec|
  spec.name          = "em-synchrony-dataone-vin"
  spec.version       = EventMachine::Synchrony::DataoneVin::VERSION
  spec.authors       = ["Scott Nielsen", "Jake Mallory"]
  spec.email         = ["scottnielsen5@gmail.com", "tinomen@gmail.com"]
  spec.description   = %q{A client for the Dataone vindecoding service that runs with EM::Synchrony}
  spec.summary       = %q{A client for the Dataone vindecoding service that runs with EM::Synchrony}
  spec.homepage      = "https://github.com/scizo/em-synchrony-dataone-vin"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "em-http-request", "~> 1.1.2"
  spec.add_dependency "em-synchrony",    "~> 1.0.3"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", "~> 0.9.6"
end
