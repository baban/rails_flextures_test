# encoding: utf-8

require 'spec_helper'

describe Flextures do
  describe "Loader::" do
    describe "::file_exist " do
      context "only csv files" do
        context "データをパースして必要な情報を返す" do
          before do
            @table_name, @file_name, @ext = Flextures::Loader::file_exist(table:'users', file:"onlycsv")
          end

          it "data size is 3" do
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
      context "only yaml files" do
        context "データをパースして必要な情報を返す" do
          before do
            @table_name, @file_name, @ext = Flextures::Loader::file_exist(table:'users', file:"onlyyaml")
          end

          it "data size is 3" do
            Flextures::Loader::file_exist(table:'users', file:"onlyyml").size.should==3
          end

          it "return table name" do
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
      context "exist coth files(yaml and csv)" do
        context "csv優先で探索して必要な情報を返す" do
          before do
            @table_name, @file_name, @ext = Flextures::Loader::file_exist(table:'users', file:"bothexist")
          end

          it "size is 3" do
            Flextures::Loader::file_exist(table:'users', file:"bothexist").size.should==3
          end

          it "return table name" do
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
      context "if yamlan csv files is esist" do
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

