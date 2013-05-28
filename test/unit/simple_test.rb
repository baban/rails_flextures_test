# encoding: utf-8

require 'stringio'
require 'test/unit'
require 'rubygems'
require 'drb/drb'
require "shoulda"

class SimpleTest < Test::Unit::TestCase
  should "テストの作動確認" do
    assert_equal true, true
  end
end

