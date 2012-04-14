# encoding: utf-8

require 'spec_helper'

describe Flextures do
  before do
    `rm spec/fixtures/users.csv 2>/dev/null`
    `rm spec/fixtures/users.yml 2>/dev/null`
    `cp spec/fixtures_bkup/users.csv spec/fixtures/users.csv`
  end

  describe "RSpec::Hooks" do
    context "::flextures " do 
      flextures :users

      it "はspec中でfixtureのロードを行う" do
        User.count.should == 3
      end

      it "は毎回fixtureをロードする" do
        User.count.should == 3
      end

      it "itemを最初から2つづつ持っている" do
        Item.count.should == 6
      end
    end

    context "::flextures " do
      it "を呼ばないのでロードしない" do
        klass = Class.new(ActiveRecord::Base){|o| o.table_name= :items }
        klass.count.should==0
      end
    end

    context "::flextures " do
      flextures :users => :users_another3
      it "で指定した別名のファイルをロードする" do
        klass = Class.new(ActiveRecord::Base){|o| o.table_name=:users }
        klass.count.should==3
        klass.first.name.should == "ほげ"
      end
    end

    context "::flextures " do
      flextures :users => :"foo/users"
      it "で指定したディレクトリのファイルをロードする" do
        klass = Class.new(ActiveRecord::Base){|o| o.table_name=:users }
        klass.count.should==3
        klass.first.name.should == "foo"
      end
    end

    context "::flextures " do
      fixtures :items
      it "fixturesと組み合わせても使える" do
        klass = Class.new(ActiveRecord::Base){|o| o.table_name=:items }
        klass.count.should==5
      end
    end

    describe "fixtureの連続ロード" do
      fixtures :items

      describe "fixturesをLoad" do
        fixtures :guilds
        it "正常にLoad" do
          klass = Class.new(ActiveRecord::Base){|o| o.table_name=:guilds }
          klass.count.should==4
          klass = Class.new(ActiveRecord::Base){|o| o.table_name=:items }
          klass.count.should==5
        end
      end

      describe "同じfixturesを再びロード" do
        fixtures :guilds
        it "正常にロードできる" do
          klass = Class.new(ActiveRecord::Base){|o| o.table_name=:guilds }
          klass.count.should==4
        end
      end
    end
  end
end

