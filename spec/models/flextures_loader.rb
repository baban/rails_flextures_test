# encoding: utf-8

require 'spec_helper'

describe Flextures do
  describe "Loader::" do
=begin
    describe :find_file do
      context do
        before do
          file_name = "users"
          dir_name = Flextures::LOAD_DIR
          format = { table: "users" }
          @method, @inpfile = Flextures::Loader::find_file file_name, dir_name, format
        end

        it "は見つけたファイルの拡張子を返す" do
          @method.should == :csv
        end

        it "は見つけたファイルの名前を返す" do
          @inpfile.should == "#{Flextures::LOAD_DIR}users.csv"
        end
      end
    end
=end
    describe :yml do
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

    describe "csv " do
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

    describe "load " do
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
  end
end

