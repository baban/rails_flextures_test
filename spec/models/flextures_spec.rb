# encoding: utf-8

require 'spec_helper'

describe Flextures do
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
# * rake db:flextures:dump M=User OPTIONS=silent,unfilter
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

    context "when option is empty" do
      before do
        @format = Flextures::ARGS.parse
      end
      it " get all table name data " do
        @format.size.should == ActiveRecord::Base.connection.tables.size - 1
      end
    end

    context "when MODEL option is exist" do
      before do
        ENV["MODEL"] = "User"
        @format = Flextures::ARGS.parse
      end
      it "table information is equal model data" do
        @format.first[:table].should == "users"
      end
      after do
        ENV.delete("MODEL")
      end
    end

    context "when M option is exist" do
      before do
        ENV["M"] = "User"
        @format = Flextures::ARGS.parse
      end
      it "table information is equal model data" do
        @format.first[:table].should == "users"
      end
      after do
        ENV.delete("M")
      end
    end

    context "when DIR option is exist" do
      before do
        ENV["M"] = "User"
        ENV["DIR"] = "test/fixtures/"
        @format = Flextures::ARGS.parse
      end
      it "dump directrory information is changed" do
        @format.first[:dir].should == "test/fixtures/"
      end
      after do
        ENV.delete("M")
        ENV.delete("DIR")
      end
    end

    context "when D option is exist" do
      before do
        ENV["M"] = "User"
        ENV["D"] = "test/fixtures/"
        @format = Flextures::ARGS.parse
      end
      it "dump directrory information is changed" do
        @format.first[:dir].should == "test/fixtures/"
      end
      after do
        ENV.delete("M")
        ENV.delete("D")
      end
    end

    context "when FIXTURES options is includeed" do
      it " FIXTURES=でもダンプするファイルを変更できる " do
        ENV["M"] = "User"
        ENV["FIXTURES"] = "user_another"
        format = Flextures::ARGS.parse
        expect( format.first[:table] ).to eq "users"
        expect( format.first[:file] ).to eq "user_another"
        ENV.delete("M")
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
    end

    context "when MINUS options is includeed" do
      before do
        ENV["TABLE"]="users"
        ENV["MINUS"]="created_at"
        @format = Flextures::ARGS.parse
      end
      it "minus colum option is exist" do
        @format.first[:minus].should be_instance_of Array
      end
      it "minus colum option is exist" do
        @format.first[:minus].should == ["created_at"]
      end
      after do
        ENV.delete "TABLE"
        ENV.delete "MINUS"
      end
    end

    context "when PLUS options is includeed" do
      before do
        ENV["TABLE"]="users"
        ENV["PLUS"]="hoge"
        @format = Flextures::ARGS.parse
      end
      it "minus colum option is exist" do
        @format.first[:plus].should be_instance_of Array
      end
      it "minus colum option is exist" do
        @format.first[:plus].should == ["hoge"]
      end
      after do
        ENV.delete "TABLE"
        ENV.delete "PLUS"
      end
    end
    
    context "when OPTIONS options is includeed" do
      context "OPTIONS include 'silent' value" do
        before do
          ENV["TABLE"]="users"
          ENV["OPTIONS"]="silent"
          @format = Flextures::ARGS.parse
        end
        it "minus colum option is exist" do
          @format.first[:silent].should be_true
        end
        after do
          ENV.delete "TABLE"
          ENV.delete "OPTIONS"
        end
      end
      context "OPTIONS include 'unfilter' value" do
        before do
          ENV["TABLE"]="users"
          ENV["OPTIONS"]="unfilter"
          @format = Flextures::ARGS.parse
        end
        it "minus colum option is exist" do
          @format.first[:unfilter].should be_true
        end
        after do
          ENV.delete "TABLE"
          ENV.delete "OPTIONS"
        end
      end
      context "OPTIONS include 'unfilter' value" do
        before do
          ENV["TABLE"]="users"
          ENV["OPTIONS"]="strict"
          @format = Flextures::ARGS.parse
        end
        it "minus colum option is exist" do
          @format.first[:strict].should be_true
        end
        after do
          ENV.delete "TABLE"
          ENV.delete "OPTIONS"
        end
      end
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

