# encoding: utf-8

require 'spec_helper'

describe Flextures do
# item_controller でだけ特別なfixturesを読み込みたいときは
#
# test/fixtures/item/users.yml とコントローラー名で指定可能
#
# test/fixtures/item/buy/users.yml とするとアクション名と対応する
#
# flextures { controller:'item', action:'list' }, :users, :items
# とすると
# 1. test/fixtures/item/list/users.csv
# 2. test/fixtures/item/users.csv
# 3. test/fixtures/users.csv
# の順番にファイルを探して、一番最初にあったcsvかyamlをロードす
#
# flextures { dir: "users" }, :users
# で指定されたディレクトリのデータをロード
# 階差ロード機能 diffload
#
# rake db:flextures:generate でロード＆ダンプ
# rake db:flextures:dump M=User OPTIONS=silent,unfilter,csv,yml
# rake db:flextures:dump MINUS=id,count でカラムを削除してダンプ
# rake db:flextures:dump PLUS=id,count でカラムを追加してダンプ
# rake db:flextures:load ERROR=strict でエラーメッセージの表示レベルを指定
#
# FixtureサポートをShouldaで行えるようにしておく
#
# Flexturs::ErrorLevel Fatal, Error, Warning, Info
# 読み込む順番の大切さ
# マスターデータからしか読み込めないことの情報を伝えておく
# fixtures マスターデータ
# flextures その他
# の順番でのロード
#
# データのロード
# fixturesのロード
# flexturesの消去
# flexturesのロード
#
# users.csv.erb 等の拡張子の場合、一度erbとして処理してから読み込みをする
#
# ActiveRecord::TestFixtures
# Mock関数を作っておく
#
# オプションでデータを厳密に読んで矛盾する列で エラーをraiseする
#
# flextures { cache: true }, :users
# でテーブルの中身がキャッシュされている場合、再ロードは行わない
#
  describe "ARGS::parse" do
    before do
      ENV.delete "TABLE"
      ENV.delete "T"
      ENV.delete "DIR"
      ENV.delete "D"
      ENV.delete "MODEL"
      ENV.delete "M"
      ENV.delete "FIXTURES"
    end

    it " 指定がないときは全テーブル名前取得 " do
      format = Flextures::ARGS.parse
      format.size.should == ActiveRecord::Base.connection.tables.size - 1
    end

    it " MODEL=モデル名を設定している場合 " do
      ENV["MODEL"] = "User"
      format = Flextures::ARGS.parse
      format.first[:table].should == "users"
      ENV.delete("MODEL")
    end

    it " M=モデル名を設定している場合 " do
      ENV["M"] = "User"
      format = Flextures::ARGS.parse
      format.first[:table].should == "users"
      ENV.delete("M")
    end

    it " DIR=でダンプするディレクトリを変更できる " do
      ENV["M"] = "User"
      ENV["DIR"] = "test/fixtures/"
      format = Flextures::ARGS.parse
      format.first[:dir].should == "test/fixtures/"
      ENV.delete("M")
      ENV.delete("DIR")
    end

    it " D=でもダンプするディレクトリを変更できる " do
      ENV["M"] = "User"
      ENV["D"] = "test/fixtures/"
      format = Flextures::ARGS.parse
      format.first[:dir].should == "test/fixtures/"
      ENV.delete("M")
      ENV.delete("D")
    end

    it " FIXTURES=でもダンプするファイルを変更できる " do
      ENV["M"] = "User"
      ENV["FIXTURES"] = "user_another"
      format = Flextures::ARGS.parse
      expect( format.first[:table] ).to eq "users"
      expect( format.first[:file] ).to eq "user_another"
      ENV.delete("M")
      ENV.delete("FIXTURES")
    end

    it " FIXTURES=でもダンプするディレクトリを変更できる " do
      ENV["FIXTURES"] = "users,items"
      format = Flextures::ARGS.parse
      format.size.should == 2
      expect( format.first[:table] ).to eq "users"
      expect( format.first[:file] ).to eq "users"
      expect( format[1][:table] ).to eq "items"
      expect( format[1][:file] ).to eq "items"
      ENV.delete("FIXTURES")
    end

    it " FIXTURES=でもダンプするファイルを変更できる " do
      ENV["M"] = "User"
      ENV["FIXTURES"] = "user_another"
      format = Flextures::ARGS.parse
      format.first[:table].should == "users"
      format.first[:file].should == "user_another"
      ENV.delete("M")
      ENV.delete("FIXTURES")
    end

    it " FIXTURES=でもダンプするファイルを変更できる " do
      ENV["FIXTURES"] = "users,items"
      format = Flextures::ARGS.parse
      format.first[:table].should == "users"
      format.first[:file].should == "users"
      format[1][:table].should == "items"
      format[1][:file].should == "items"
      ENV.delete("FIXTURES")
    end

    it "存在しているファイルはそのまま返す" do
      files = ["users"]
      files.select(&Flextures::ARGS.exist).should == files
    end

    it "存在しているファイルだけを絞り込んで返す" do
      files = ["users", "fake_file"]
      files.select(&Flextures::ARGS.exist).should == ["users"]
    end
  end

  # テーブルをモデル化出来ているかテスト
  describe ".create_model" do
    %W{users}.each do |table_name|
      it "(#{table_name})" do
        table_model = Flextures.create_model table_name
        table_model.table_name.should == table_name
      end
    end
  end

  describe ".deletable_tables" do
    it "消去できるテーブルを返す" do
       table_names = Flextures::deletable_tables
       table_names.should == ["admin_users","guilds", "items", "s_user", "upload_images", "users"]
    end
  end

  describe "Factory::" do
=begin
    describe "get " do
      it "(table_name)は処理すべき関数を返す" do
        Flextures::Factory.get(:users).should be_instance_of Proc
      end

      it "(not_exist_table) は、関数を返さない" do
        Flextures::Factory.get(:foo).should == nil
      end
    end

    describe " " do
      it "[table_name] は処理すべき関数を返す" do
        Flextures::Factory[:users].should be_instance_of Proc
      end

      it "[not_exist_table] は、関数を返さない" do
        Flextures::Factory.get(:foo).should == nil
      end
    end
=end

    context "でデータを作成すると" do
      it "元のデータに変更をかけて、ハッシュを返す" do
#        fn = Flextures::Factory[:test]
#        h = { foo:10 }
#        h = Flextures::OpenStruct.new h
#        fn.call h
#        h = h.to_hash
#        h[:foo].should == 15
      end
    end
  end
end

