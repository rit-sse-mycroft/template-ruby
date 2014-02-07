# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mycroft/version'

Gem::Specification.new do |spec|
  spec.name          = "mycroft"
  spec.version       = Mycroft::VERSION
  spec.authors       = ["rit-sse"]
  spec.description   = %q{Gem for creating a mycroft app in ruby.}
  spec.summary       = %q{Gem for creating a mycroft app in ruby.}
  spec.homepage      = "https://github.com/rit-sse-mycroft/app-templates/tree/master/ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_runtime_dependency "thor"
  spec.add_runtime_dependency "activesupport"
  spec.add_runtime_dependency "i18n"
  spec.add_runtime_dependency "colorize"
  spec.add_runtime_dependency "yell"
end
