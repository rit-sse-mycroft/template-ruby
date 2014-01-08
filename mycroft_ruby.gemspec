# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mycroft_ruby/version'

Gem::Specification.new do |spec|
  spec.name          = "mycroft_ruby"
  spec.version       = MycroftRuby::VERSION
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
end
