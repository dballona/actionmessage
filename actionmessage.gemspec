# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'action_message/version'

Gem::Specification.new do |spec|
  spec.name          = "actionmessage"
  spec.version       = ActionMessage::VERSION
  spec.authors       = ["Diego Ballona"]
  spec.email         = ["root@dballona.com"]

  spec.summary       = "ActionMailer heavily-inspired gem to handle SMS/Text Messages"
  spec.description   = "ActionMailer heavily-inspired gem to handle SMS/Text Messages"
  spec.homepage      = "http://github.com/dballona/actionmessage"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'actionpack', '>= 4.0.0'
  spec.add_dependency 'actionview', '>= 4.0.0'
  spec.add_dependency 'twilio-ruby', '>= 4.11.1'
  
  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
