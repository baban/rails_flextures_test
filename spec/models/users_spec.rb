# encoding: utf-8

require 'spec_helper'

describe User do
  describe "#user" do
    flextures :users
    before do
      @before_user = User.first
      @user = User.first
      @user.levelup
    end
    it "max_hpが上昇している" do
      @user.max_hp.should > @before_user.max_hp+3
    end
  end
end

