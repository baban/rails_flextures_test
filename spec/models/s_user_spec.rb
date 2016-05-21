require 'spec_helper'

describe SUser do
  flextures :s_user

  context "のデータを取り出し" do
    it "キャリアは想定通りになっている" do
      u = CUser.first
      u.carrier.should == 2
    end
  end
end
