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
# procの関数合成を出来る*演算子を定義する
#
# オプションでデータを厳密に読んで矛盾する列でえらーをraiseする
#
  context "ARGS::parse" do
    it " 指定がないときは全テーブル名前取得 " do
      format = Flextures::ARGS.parse
      format.size.should == ActiveRecord::Base.connection.tables.size
    end

    it " TABLE=テーブル名 を設定している場合 " do
      ENV["TABLE"] = "users"
      format = Flextures::ARGS.parse
      format.first[:table].should == "users"
    end

    it " MODEL=モデル名を設定している場合 " do
      ENV["MODEL"] = "User"
      format = Flextures::ARGS.parse
      format.first[:table].should == "users"
    end

    it " T=テーブル名を設定している場合 " do
      ENV["T"] = "s_user"
      format = Flextures::ARGS.parse
      format.first[:table].should == "users"
    end

    it " M=モデル名を設定している場合 " do
      ENV["M"] = "User"
      format = Flextures::ARGS.parse
      format.first[:table].should == "users"
    end

    it " DIR=でダンプするディレクトリを変更できる " do
      ENV["M"] = "User"
      ENV["DIR"] = "test/fixtures/"
      format = Flextures::ARGS.parse
      format.first[:dir].should == "test/fixtures/"
    end

    it " D=でもダンプするディレクトリを変更できる " do
      ENV["M"] = "User"
      ENV["D"] = "test/fixtures/"
      format = Flextures::ARGS.parse
      format.first[:dir].should == "test/fixtures/"
    end

    it " FIXTURES=でもダンプするファイルを変更できる " do
      ENV["M"] = "User"
      ENV["FIXTURES"] = "user_another"
      format = Flextures::ARGS.parse
      format.first[:table].should == "users"
      format.first[:file].should == "user_another"
    end

    it " FIXTURES=でもダンプするディレクトリを変更できる " do
      ENV["FIXTURES"] = "users,items"
      format = Flextures::ARGS.parse
      format.size.should == 2
      format.first[:table].should == "users"
      format.first[:file].should == "users"
      format[1][:table].should == "items"
      format[1][:file].should == "items"
    end

    it " FIXTURES=でもダンプするファイルを変更できる " do
      ENV["M"] = "User"
      ENV["FIXTURES"] = "user_another"
      format = Flextures::ARGS.parse
      format.first[:table].should == "users"
      format.first[:file].should == "user_another"
    end

    it " FIXTURES=でもダンプするファイルを変更できる " do
      ENV["FIXTURES"] = "users,items"
      format = Flextures::ARGS.parse
      format.first[:table].should == "users"
      format.first[:file].should == "users"
      format[1][:table].should == "items"
      format[1][:file].should == "items"
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
  describe "create_model" do
    %W{users}.each do |table_name|
      it "(#{table_name})" do
        table_model = Flextures.create_model table_name
        table_model.table_name.should == table_name
      end
    end
  end

  describe "Loader::" do
    describe :find_file do
=begin
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
=end
    end

    describe :yml do
=begin
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
=end
    end

    describe "csv " do
      before { User.delete_all }

      it "を標準で読み込み" do
#        User.delete_all
#        Flextures::Loader::csv table: "users"
#        User.first.id.should == 1
      end

      it "カラムを追加した状態で読み込み" do
#         テスト様のデータに移動
#        `cp spec/fixtures/guilds_column_add.csv spec/fixtures/guilds.csv`
#        klass = Class.new(ActiveRecord::Base){ |o| o.table_name="guilds" }
#        klass.delete_all
#        Flextures::Loader::csv table: "guilds"
#        klass.first.id.should == 1
#        # 元に戻しておく
#        `cp spec/fixtures_bkup/guilds.csv spec/fixtures/`
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

    describe "" do
=begin
      it "" do
        klass = Class.new(ActiveRecord::Base){ |o| o.table_name= "guilds"}
        klass.delete_all
        Flextures::Loader::csv table: 'guilds'
        klass.first.rank.should==2
      end
=end
    end
  end
end

