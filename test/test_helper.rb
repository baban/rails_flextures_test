# encoding: utf-8
ENV["RAILS_ENV"] = "test"

require 'stringio'
require 'test/unit'
require 'rubygems'
require 'drb/drb'
require "shoulda"
#require File.dirname(__FILE__) + '/../lib/flextures'

##ここ以下にlibにおいたソースを追記する

require "flextures"

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
