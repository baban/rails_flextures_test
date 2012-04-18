# encoding: utf-8

require 'spec_helper'

describe :FixtureLoadTest do
  context :load_fixture do 
    fixtures :items
    
    it "はspec中でfixtureのロードを行う" do
      Item.count.should == 5
    end
  end
  context :not_load_fixture do 
    it "はspec中でfixtureのロードを行う" do
      Item.count.should == 0 # アイテム所持数は5個のままだったのでエラー！
    end
  end
end

