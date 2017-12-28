
$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
$LOAD_PATH.unshift File.dirname(__FILE__)

ENV['RAILS_ENV'] = 'test'

require "bundler/setup"
require "grpc_for_rails"

require 'dummy_app/config/environment'
require 'rails/test_help'

require "minitest/autorun"
