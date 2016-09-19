require 'simplecov'
require 'codecov'
SimpleCov.start
SimpleCov.formatter = SimpleCov::Formatter::Codecov

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'action_message'
