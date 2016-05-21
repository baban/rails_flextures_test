# encoding: utf-8

require 'spec_helper'

describe Flextures do
  describe "RSpec::Hooks" do
    fixtures :users, :items, :guilds
    describe "::flextures " do
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

      context "option setting" do
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
        flextures_delete

        it "delete all table data" do
          Item.count.should==0
        end
      end

      context "set table name option" do
        context "items and guilds tables Load" do
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
  end
end
