# encoding: utf-8

require 'spec_helper'

describe Flextures do
  describe "Loader::" do
    describe "TRANSLATER" do
      describe :binary do
        it "nil" do
          Flextures::Loader::TRANSLATER[:binary].call(nil).should == nil
        end
      end
      describe :boolean do
        it "nilはそのまま" do
          Flextures::Loader::TRANSLATER[:boolean].call(nil).should == nil
        end
        it "trueもそのまま" do
          Flextures::Loader::TRANSLATER[:boolean].call(true).should == true
        end
        it "falseもそのまま" do
          Flextures::Loader::TRANSLATER[:boolean].call(false).should == false
        end
        it "0" do
          Flextures::Loader::TRANSLATER[:boolean].call(0).should == false
        end
        it "1" do
          Flextures::Loader::TRANSLATER[:boolean].call(1).should == true
        end
        it "-1" do
          Flextures::Loader::TRANSLATER[:boolean].call(-1).should == true
        end
        it "空白文字" do
          Flextures::Loader::TRANSLATER[:boolean].call("").should == false
        end
        it "文字" do
          Flextures::Loader::TRANSLATER[:boolean].call("Hello").should == true
        end
      end
      describe :date do
        it "正常値の文字列" do
          Flextures::Loader::TRANSLATER[:date].call("2011/11/21").strftime("%Y/%m/%d").should == "2011/11/21"
        end
        it "Timeオブジェクト" do
          now = Time.now
          Flextures::Loader::TRANSLATER[:date].call(now).strftime("%Y/%m/%d").should == now.strftime("%Y/%m/%d")
        end
        it "DateTimeオブジェクト" do
          now = DateTime.now
          Flextures::Loader::TRANSLATER[:date].call(now).strftime("%Y/%m/%d").should == now.strftime("%Y/%m/%d")
        end
        it "日付っぽい数字" do
          now = "20111121"
          Flextures::Loader::TRANSLATER[:date].call(now).should be_instance_of Date
        end
        it "nil" do
          Flextures::Loader::TRANSLATER[:date].call(nil).should == nil
        end
        it "空文字" do
          Flextures::Loader::TRANSLATER[:date].call("").should == nil
        end
      end
      describe :datetime do
        it "正常値の文字列" do
          Flextures::Loader::TRANSLATER[:date].call("2011/11/21").strftime("%Y/%m/%d").should == "2011/11/21"
        end
        it "Timeオブジェクト" do
          now = Time.now
          Flextures::Loader::TRANSLATER[:date].call(now).strftime("%Y/%m/%d").should == now.strftime("%Y/%m/%d")
        end
        it "DateTimeオブジェクト" do
          now = DateTime.now
          Flextures::Loader::TRANSLATER[:date].call(now).strftime("%Y/%m/%d").should == now.strftime("%Y/%m/%d")
        end
        it "日付っぽい数字" do
          now = "20111121"
          Flextures::Loader::TRANSLATER[:date].call(now).should be_instance_of Date
        end
        it "nil" do
          Flextures::Loader::TRANSLATER[:date].call(nil).should == nil
        end
        it "空文字" do
          Flextures::Loader::TRANSLATER[:date].call("").should == nil
        end
      end
      describe :decimal do
        it "null" do
          Flextures::Loader::TRANSLATER[:decimal].call(nil).should === nil
        end
      end
      describe :float do
        it "null" do
          Flextures::Loader::TRANSLATER[:float].call(nil).should === nil
        end
      end
      describe :integer do
        it "null" do
          Flextures::Loader::TRANSLATER[:integer].call(nil).should === nil
        end
      end
      describe :string do
        it "null" do
          Flextures::Loader::TRANSLATER[:string].call(nil).should === nil
        end
        it "空文字" do
          Flextures::Loader::TRANSLATER[:string].call("").should === ""
        end
        it "タブ混じり" do
          s="\taaaaa"
          Flextures::Loader::TRANSLATER[:string].call(s).should === s
        end
        it "改行混じり" do
          s="aa\naaa"
          Flextures::Loader::TRANSLATER[:string].call(s).should === s
        end
        it "スペース混じり" do
          s="aa aaa"
          Flextures::Loader::TRANSLATER[:string].call(s).should === s
        end
        # "@#%{}|[]&:`'>?~"
      end
      describe :text do
        it "null" do
          Flextures::Loader::TRANSLATER[:text].call(nil).should === nil
        end
        it "空文字" do
          Flextures::Loader::TRANSLATER[:text].call("").should === ""
        end
      end
      describe :time do
        it "正常値の文字列" do
          Flextures::Loader::TRANSLATER[:time].call("2011/11/21").strftime("%Y/%m/%d").should == "2011/11/21"
        end
        it "Timeオブジェクト" do
          now = Time.now
          Flextures::Loader::TRANSLATER[:time].call(now).strftime("%Y/%m/%d").should == now.strftime("%Y/%m/%d")
        end
        it "DateTimeオブジェクト" do
          now = DateTime.now
          Flextures::Loader::TRANSLATER[:time].call(now).strftime("%Y/%m/%d").should == now.strftime("%Y/%m/%d")
        end
        it "日付っぽい数字はDateTime型" do
          now = "20111121"
          Flextures::Loader::TRANSLATER[:time].call(now).should be_instance_of DateTime
        end
        it "nilはnilのまま" do
          Flextures::Loader::TRANSLATER[:time].call(nil).should == nil
        end
        it "空文字はnil" do
          Flextures::Loader::TRANSLATER[:time].call("").should == nil
        end
      end
      describe :timestamp do
        it "正常値の文字列はDateTimeに変換" do
          Flextures::Loader::TRANSLATER[:timestamp].call("2011/11/21").strftime("%Y/%m/%d").should == "2011/11/21"
        end
        it "Timeオブジェクト" do
          now = Time.now
          Flextures::Loader::TRANSLATER[:timestamp].call(now).strftime("%Y/%m/%d").should == now.strftime("%Y/%m/%d")
        end
        it "DateTimeオブジェクトはDateTime" do
          now = DateTime.now
          Flextures::Loader::TRANSLATER[:timestamp].call(now).strftime("%Y/%m/%d").should == now.strftime("%Y/%m/%d")
        end
        it "日付っぽい数字はDateTime" do
          now = "20111121"
          Flextures::Loader::TRANSLATER[:timestamp].call(now).should be_instance_of DateTime
        end
        it "nilからnil" do
          Flextures::Loader::TRANSLATER[:timestamp].call(nil).should == nil
        end
        it "空文字はnil" do
          Flextures::Loader::TRANSLATER[:timestamp].call("").should == nil
        end
      end
    end

    describe "::file_exist " do
      context "csvのみ" do
        context "データをパースして必要な情報を返す" do
          before do
            @table_name, @file_name, @ext = Flextures::Loader::file_exist(table:'users', file:"onlycsv")
          end

          it "データは３つ" do
            Flextures::Loader::file_exist(table:'users', file:"onlycsv").size.should==3
          end

          it "テーブル名" do
            @table_name.should=="users"
          end

          it "ロードするファイル名" do
            @file_name.should=="spec/fixtures/onlycsv"
          end

          it "ファイルの拡張子" do
            @ext.should== :csv
          end
        end
      end
      context "yamlのみのとき" do
        context "データをパースして必要な情報を返す" do
          before do
            @table_name, @file_name, @ext = Flextures::Loader::file_exist(table:'users', file:"onlyyaml")
          end

          it "データは３つ" do
            Flextures::Loader::file_exist(table:'users', file:"onlyyml").size.should==3
          end

          it "テーブル名" do
            @table_name.should=="users"
          end

          it "ロードするファイル名" do
            @file_name.should=="spec/fixtures/onlyyaml"
          end

          it "ファイルの拡張子" do
            @ext.should== :yml
          end
        end
      end
      context "両方あるとき" do
        context "csv優先で探索して必要な情報を返す" do
          before do
            @table_name, @file_name, @ext = Flextures::Loader::file_exist(table:'users', file:"bothexist")
          end

          it "データは３つ" do
            Flextures::Loader::file_exist(table:'users', file:"bothexist").size.should==3
          end

          it "テーブル名" do
            @table_name.should=="users"
          end

          it "ロードするファイル名" do
            @file_name.should=="spec/fixtures/bothexist"
          end

          it "ファイルの拡張子" do
            @ext.should== :csv
          end
        end
      end
      context "両方存在しないとき" do
        context "データをパースして必要な情報を返す" do
          before do
            @table_name, @file_name, @ext = Flextures::Loader::file_exist(table:'users', file:"notexist")
          end

          it "データは３つ" do
            Flextures::Loader::file_exist(table:'users', file:"notexist").size.should==3
          end

          it "テーブル名" do
            @table_name.should=="users"
          end

          it "ロードするファイル名" do
            @file_name.should=="spec/fixtures/notexist"
          end

          it "ファイルの拡張子" do
            @ext.should== nil
          end
        end
      end
    end

    describe "::load " do
      before do
        `rm spec/fixtures/users.csv 2>/dev/null`
        `rm spec/fixtures/users.yml 2>/dev/null`
        `cp spec/fixtures_bkup/users_load.csv spec/fixtures/users.csv`
        `cp spec/fixtures_bkup/users_load.yml spec/fixtures/users.yml`
      end

      before { User.delete_all }

      it "はcsv優先でファイルをロードする" do
        Flextures::Loader::load table: "users"
        User.first.id.should == 1
      end

      it "はfile: 'ファイル名' で指定した場合、そのファイルを取り出す" do
        method = Flextures::Loader::load table: "users", file: "user_another2"
        User.first.name.should == 'ggg'
      end
    end

    describe "::csv " do
      before do
        `rm spec/fixtures/users.csv 2>/dev/null`
        `rm spec/fixtures/users.yml 2>/dev/null`
        `cp spec/fixtures_bkup/users_load.csv spec/fixtures/users.csv`
      end

      before { User.delete_all }

      it "を標準で読み込み" do
        User.delete_all
        Flextures::Loader::csv table: "users"
        User.first.id.should == 1
      end

      it "カラムを追加した状態で読み込み" do
        # テスト様のデータに移動
        `cp spec/fixtures/guilds_column_add.csv spec/fixtures/guilds.csv`
        klass = Class.new(ActiveRecord::Base){ |o| o.table_name="guilds" }
        klass.delete_all
        Flextures::Loader::csv table: "guilds"
        klass.first.id.should == 1
        # 元に戻しておく
        `cp spec/fixtures_bkup/guilds.csv spec/fixtures/`
      end

      it "カラムを削除された状態で自動補完を作動" do
        `cp spec/fixtures/guilds_column_dec.csv spec/fixtures/guilds.csv`
        klass = Class.new(ActiveRecord::Base){ |o| o.table_name="guilds" }
        Flextures::Loader::csv table: "guilds"
        klass.first.id.should == 1
        `cp spec/fixtures_bkup/guilds.csv spec/fixtures/`
      end

      it " file: 'ファイル名' で csv ファイルを指定すると、そのファイルを読み込んでテーブルに反映する" do
        klass = Class.new(ActiveRecord::Base){ |o| o.table_name= "users" }
        Flextures::Loader::csv table: "users", file: "user_another"
        klass.first.id == 1
      end

      after { User.delete_all }
    end

    describe "::yml" do
      before do
        `rm spec/fixtures/users.csv 2>/dev/null`
        `rm spec/fixtures/users.yml 2>/dev/null`
        `cp spec/fixtures_bkup/users_load.yml spec/fixtures/users.yml`
      end

      before { User.delete_all }

      it "" do
        Flextures::Loader::yml table: "users"
        User.first.id.should == 1
      end

      it " file: 'ファイル名' で yml ファイルを指定すると、そのファイルを読み込んでテーブルに反映する" do
        klass = Class.new(ActiveRecord::Base){ |o| o.table_name= "users" }
        Flextures::Loader::yml table: "users", file: "user_another"
        klass.first.name.should == 'jjj'
      end
    end
  end
end

