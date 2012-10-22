# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'propeller/version'

Gem::Specification.new do |gem|
  gem.name          = "propeller"
  gem.version       = Propeller::VERSION
  gem.authors       = ["wilkie"]
  gem.email         = ["wilkie05@gmail.com"]
  gem.description   = %q{Allows easy configuration and deployment of applications.}
  gem.summary       = %q{We are reaching a time when we want our applications to be widely deployed by as many people as possible, and we want to impose little to no technical assumptions on our users. This gem helps people install your applications directly to several different hosting options and allows them to consistently enable extra features.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "git"
end
