# encoding: utf-8

require 'test_helper'

class LoadTest < Test::Unit::TestCase
  context "context" do
    context "flextures function" do
      flextures :users
      should "test data is exist" do
        assert_equal true, User.first.is_a?(User)
      end
    end

    context "flextures_delete" do
      flextures :users
      flextures_delete :users
      should "test data is deleted" do
        assert_equal nil, User.first
      end
    end

    context "::flextures_options" do
      flextures_set_options( cache: true )

      should "option is setted" do
        Flextures::Loader::flextures_options.should == { cache: true }
      end

      context "add option" do
        flextures_set_options( unfilter: true )
        should "option is added" do
          Flextures::Loader::flextures_options.should == { cache: true, unfilter: true }
        end
      end

      context "new context" do
        should "added option is deleted" do
          Flextures::Loader::flextures_options.should == { cache: true }
        end
      end
    end
  end
end

