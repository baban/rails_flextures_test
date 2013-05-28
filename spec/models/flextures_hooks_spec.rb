# encoding: utf-8

require 'spec_helper'

describe Flextures do
  describe "RSpec::Hooks" do
    describe "::flextures " do
      before do
        `rm spec/fixtures/users.csv 2>/dev/null`
        `rm spec/fixtures/users.yml 2>/dev/null`
        `cp spec/fixtures_bkup/users.csv spec/fixtures/users.csv`
      end

      context "通常動作" do
        flextures :users

        it "spec中でfixtureのロードを行う" do
          User.count.should == 3
        end

        it "毎回fixtureをロードする" do
          User.count.should == 3
        end

        it "itemを最初から2つづつ持っている" do
          Item.count.should == 6
        end
      end 

      context "flexturesを呼ばない場合" do
        it "呼ばないのでロードしない" do
          klass = Class.new(ActiveRecord::Base){|o| o.table_name= :items }
          klass.count.should==0
        end
      end

      context "違うファイルをロードした時" do
        flextures :users => :users_another3
        it "で指定した別名のファイルをロードする" do
          klass = Class.new(ActiveRecord::Base){|o| o.table_name=:users }
          klass.count.should==3
          klass.first.name.should == "ほげ"
        end
      end

      context "ディレクトリ違いLoad" do
        flextures :users => "foo/users"
        it "で指定したディレクトリのファイルをロードする" do
          klass = Class.new(ActiveRecord::Base){|o| o.table_name=:users }
          klass.count.should==3
          klass.first.name.should == "foo"
        end
      end

      context "fxituresとの組み合わせ" do
        fixtures :items
        it "fixturesもLoadしてる" do
          klass = Class.new(ActiveRecord::Base){|o| o.table_name=:items }
          klass.count.should==5
        end
      end

      context "連続ロード" do
        fixtures :items
        
        context "fixturesをLoad" do
          fixtures :guilds
          it "正常にLoad" do
            klass = Class.new(ActiveRecord::Base){|o| o.table_name=:guilds }
            klass.count.should==4
            klass = Class.new(ActiveRecord::Base){|o| o.table_name=:items }
            klass.count.should==5
            klass = Class.new(ActiveRecord::Base){|o| o.table_name=:users }
            klass.count.should==0
          end
        end

        context "同じfixturesを再びロード" do
          fixtures :guilds
          it "正常にロードできる" do
            klass = Guild
            klass.count.should==4
          end
        end

        context "ロード時にオプションを指定" do
          context "空オプション" do
            flextures( {}, :guilds )
            it "正常にロードできる" do
              klass = Guild
              klass.count.should==4
            end
          end
          context "cacheオプション" do
            context "trueのとき" do
            end
            context "falseのとき" do
            end
          end
        end
      end
    end

    describe "::flextures_delete" do
      context "全テーブル指定削除" do
        fixtures :items
        flextures_delete
        it "きちんと消える" do
          Item.count.should==0
        end
      end
      context "部分テーブル指定削除" do
        context "itemsとguildsをLoad、itemsは消す" do
          fixtures :items, :guilds
          flextures_delete :items
          it "Itemは指定してある きちんと消える" do
            Item.count.should==0
          end
          it "ギルドデータが 残っている" do
            Guild.count.should > 0
          end
        end
      end
    end
  end
end

