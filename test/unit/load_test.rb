# encoding: utf-8

require 'test_helper'

class LoadTest < Test::Unit::TestCase
  context "context" do
    flextures :users
    setup do
      p :setup
    end
    should "テストの作動確認" do
      p User.first
    end
  end
end

