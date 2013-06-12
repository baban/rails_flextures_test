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

      context "simple option" do
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
      end

      context "option setting" do
        context "empty option" do
          flextures( {}, :guilds )
          before do
            @klass = Guild
          end
          it "data loaded" do
            @klass.count.should==4
          end
        end
        context "cache option" do
          context "when cahce mode is true " do
            flextures( { cache: true }, :guilds )
            it "first time loading success" do
              Guild.first.should be_instance_of Guild
            end
            it "second time loading success" do
              Guild.first.should be_instance_of Guild
            end
          end
          context "when cahce mode is false " do
            flextures( { cache: false }, :guilds )
            it "first time loading success" do
              Guild.first.should be_instance_of Guild
            end
            it "second time loading success" do
              Guild.first.should be_instance_of Guild
            end
          end
        end
        context "minus option" do
          flextures( { minus:["created_at","updated_at"] }, :guilds )
          before do
            @klass = Guild
          end
          it "load normal data" do
            @klass.count.should==4
          end
          it "minus value is deleted and set new value" do
            @klass.first.created_at.to_date.should == Time.zone.now.to_date
          end
        end
        context "unfilter option" do
          before do
            User.delete_all
            Item.delete_all
          end
          flextures( { unfilter: true }, :users )
          before do
            @user = User.first
          end
          it "user don't have item" do
            @user.items.size.should == 0
          end
        end
        context "silent option" do
          flextures( { silent: true }, :guilds )
          it "not raise error" do
            expect { Guild.count.should > 0 }.not_to raise_error
          end
        end
        context "strict option" do
          flextures( { strict: true }, :guilds )
          it "not raise error" do
            expect { Guild.count.should > 0 }.not_to raise_error
          end
        end
      end
    end

    describe "::flextures_delete" do
      context "option is empty" do
        fixtures :items
        flextures_delete
        it "delete all table data" do
          Item.count.should==0
        end
      end
      context "set table name option" do
        context "items and guilds tables Load" do
          fixtures :items, :guilds
          flextures_delete :items
          it "items table deleted all data" do
            Item.count.should==0
          end
          it "but guild table data is not deleted" do
            Guild.count.should > 0
          end
        end
      end
    end

    describe "::flextures_options" do
      flextures_set_options( cache: true )
      it "option is setted" do
        Flextures::Loader::flextures_options.should == { cache: true }
      end
      context "add option" do
        flextures_set_options( unfilter: true )
        it "option is added" do
          Flextures::Loader::flextures_options.should == { cache: true, unfilter: true }
        end
      end

      context "new context" do
        it "added option is deleted" do
          Flextures::Loader::flextures_options.should == { cache: true }
        end
      end
    end
  end
end

