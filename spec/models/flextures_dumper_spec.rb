# encoding: utf-8

require 'spec_helper'
require "fileutils"

describe Flextures do
  describe "Dumper" do
    #  compare dumped data to original data
    describe ".csv " do
      before do
        `rm spec/fixtures/users.csv 2>/dev/null`
        `rm spec/fixtures/users.yml 2>/dev/null`
        `cp spec/fixtures_bkup/users_dump.csv spec/fixtures/users.csv`
      end

      context "simple dump test" do
        flextures :users

        it "dump" do
          @base = IO.read File.join( Rails.root.to_path, "/spec/fixtures/users.csv" )
          Flextures::Dumper::csv table: "users"
          @result = IO.read File.join( Rails.root.to_path, "/spec/fixtures/users.csv" )
          @base.should == @result
        end
      end

      context "chamge dump derectory" do
        flextures :users
        context "set directory option" do
          it "file is dumped changed directory" do
            from = File.join( Rails.root.to_path, "spec/fixtures/users.csv" )
            to   = File.join( Rails.root.to_path, "spec/fixtures/hoge/hoge/users.csv" )
            @base = IO.read from
            Flextures::Dumper::csv table: "users", dir:"hoge/hoge"
            @result = IO.read to
            @base.should == @result
          end
          after do
            FileUtils.rm File.join( Rails.root.to_path, "spec/fixtures/hoge/hoge/users.csv" )
          end
        end
        context "directory name is include '/' mark" do
          it "file is dumped changed directory" do
            @base = IO.read File.join( Rails.root.to_path, "/spec/fixtures/users.csv" )
            Flextures::Dumper::csv table: "users", dir:"hoge/"
            @result = IO.read File.join( Rails.root.to_path, "spec/fixtures/hoge/users.csv" )
            @base.should == @result
          end
        end
        context "make dump directory" do
          context "simple directory option" do
            it "create directroy" do
              @base = IO.read File.join( Rails.root.to_path, "/spec/fixtures/users.csv" )
              Flextures::Dumper::csv table: "users", dir:"hoge/hoge"
              @result = IO.read File.join( Rails.root.to_path, "spec/fixtures/hoge/hoge/users.csv" )
              @base.should == @result
            end
            after do
              FileUtils.rm File.join( Rails.root.to_path, "spec/fixtures/hoge/hoge/users.csv" )
            end
          end
          context "directory option include '/' mark " do
            it "create directory" do
              @base = IO.read File.join( Rails.root.to_path, "spec/fixtures/users.csv" )
              Flextures::Dumper::csv table: "users", dir:"hoge/hoge"
              @result = IO.read File.join( Rails.root.to_path, "spec/fixtures/hoge/hoge/users.csv" )
              @base.should == @result
            end
            after do
              FileUtils.rm File.join( Rails.root.to_path, "spec/fixtures/hoge/hoge/users.csv" )
            end
          end
        end
      end
      context "special character test" do
        describe :null do
          before do
            User.create( name:"hoge", sex: 0, level: 1, exp: 0, guild_id: 0, hp: 10, mp: 0 )
          end

          it "outpu null" do
            Flextures::Dumper::csv table: "users"
            path = File.join( Rails.root.to_path, "/spec/fixtures/users.csv" )
            CSV.open( path ) do |csv|
              keys = csv.shift
              values = csv.first
              values[3].should == nil
            end
          end
        end

        describe "empty string" do
          before do
            user = FactoryGirl.build(:user)
            user.profile_comment=""
            user.save
          end

          it "dump null" do
            Flextures::Dumper::csv table: "users"
            path = File.join( Rails.root.to_path, "/spec/fixtures/users.csv" )
            CSV.open( path ) do |csv|
              keys = csv.shift
              values = csv.first
              values[3].should == ""
            end
          end
        end
        # TODO: 特殊文字
        # TODO: ランダム文字生成でのテスト
        # TODO: 文字列型以外でのテスト
        # TODO: バイナリ型でのテスト
      end
      after do
        `rm spec/fixtures/users.csv 2>/dev/null`
        `rm spec/fixtures/users.yml 2>/dev/null`
        FileUtils.cp "spec/fixtures_bkup/users_dump.yml", "spec/fixtures/users.yml"
      end
    end

    # compare data dumped yaml format
    describe ".yml " do
      before do
        `rm spec/fixtures/users.csv 2>/dev/null`
        `rm spec/fixtures/users.yml 2>/dev/null`
      end
      describe "simple text" do
        before do
          FileUtils.cp "spec/fixtures_bkup/users_dump.yml", "spec/fixtures/users.yml"
        end
        describe "simple option" do
          flextures :users
          it "dump yaml data" do
            @base = IO.read File.join( Rails.root.to_path, "/spec/fixtures_bkup/users_dump.yml" )
            Flextures::Dumper::yml table: "users"
            @result = IO.read File.join( Rails.root.to_path, "/spec/fixtures/users.yml" )
            @result.should == @base
          end
        end

        context "include break line" do
          before do
            FileUtils.cp "spec/fixtures_bkup/users_dump_br.yml", "spec/fixtures/users.yml"
          end

          flextures :users

          it "dump yaml data" do
            @base = IO.read File.join( Rails.root.to_path, "/spec/fixtures_bkup/users_dump_br.yml" )
            Flextures::Dumper::yml table: "users"
            @result = IO.read File.join( Rails.root.to_path, "/spec/fixtures/users.yml" )
            @result.should == @base
          end
        end

        context "null" do
          before do
            User.create( name:"hoge", sex: 0, level: 1, exp: 0, guild_id: 0, hp: 10, mp: 0 )
          end
          it "nilをnullとしてdumpする" do
            Flextures::Dumper::yml table: "users"
            yaml = YAML.load_file( File.join( Rails.root.to_path, "/spec/fixtures/users.yml" ) )
            yaml["users_0"]["profile_comment"].should == nil
          end
        end

        context "head character is space" do
          before do
            `rm spec/fixtures/users.csv 2>/dev/null`
            `rm spec/fixtures/users.yml 2>/dev/null`
            FileUtils.cp "spec/fixtures_bkup/users_dump_space.csv", "spec/fixtures/users.csv"
          end

          flextures :users

          it "YAML data is loadable" do
            Flextures::Dumper::yml table: "users"
            file = File.join( Rails.root.to_path, "/spec/fixtures/users.yml" )
            expect { YAML.load_file( file ) }.not_to raise_error
          end

          it "head space character is deleted" do
            Flextures::Dumper::yml table: "users"
            yaml = YAML.load_file( Rails.root.to_path+"/spec/fixtures/users.yml" )
            yaml["users_0"]["name"].should == "bcde"
          end

          it "head tab character is deleted" do
            Flextures::Dumper::yml table: "users"
            yaml = YAML.load_file( Rails.root.to_path+"/spec/fixtures/users.yml" )
            yaml["users_3"]["name"].should == "llll"
            yaml["users_4"]["name"].should == "mm\nmm"
          end
        end
      end

      context "include tab character" do
        context "tab character convert to 2 space" do
          before do
            `rm spec/fixtures/users.csv 2>/dev/null`
            `rm spec/fixtures/users.yml 2>/dev/null`
            FileUtils.cp "spec/fixtures_bkup/users_dump_tab.csv", "spec/fixtures/users.csv"
          end
          flextures :users

          it "YAMLは読み込み可能" do
            Flextures::Dumper::yml table: "users"
            expect { YAML.load_file( Rails.root.to_path+"/spec/fixtures/users.yml" ) }.not_to raise_error
          end

          it "tabを２スペースに変換" do
            Flextures::Dumper::yml table: "users"
            yaml = YAML.load_file( Rails.root.to_path+"/spec/fixtures/users.yml" )
            yaml["users_0"]["name"].should == "ii a  i"
          end
        end
      end

      context "include special character" do
        let(:user){ FactoryGirl.build(:user) }
        context "special character" do
          before do
            @dump_method = ->{
              Flextures::Dumper::yml table: "users"
              YAML.load_file( Rails.root.to_path+"/spec/fixtures/users.yml" )
            }
            User.delete_all
          end
          ["[","]","{","}","|","#","@","~","!","'","$","&","^","<",">","?","-","+","=",";",":",".",",","*","`","(",")"].each do |c|
            "\"'\\"
            it c do
              user.name = c+"ブリトニー"
              user.save
              @dump_method.call
              yaml = @dump_method.call
              yaml["users_0"]["name"].should == user[:name]
            end
          end
        end
      end
      # TODO: ランダム文字生成でのテスト
      # TODO: 文字列型以外でのテスト
      # TODO: バイナリ型でのテスト
      after do
        `rm spec/fixtures/users.csv 2>/dev/null`
        `rm spec/fixtures/users.yml 2>/dev/null`
        FileUtils.cp "spec/fixtures_bkup/users_dump.yml", "spec/fixtures/users.yml"
      end
    end

    describe ".dump_attributes" do
      context "option is empty" do
        before do
          @columns = Flextures::Dumper.dump_attributes User, {}
        end
        it "data is Array" do
          @columns.should be_instance_of Array
        end
        it "array include Hash" do
          @columns.first.should be_instance_of Hash
        end
        it "Hash 'name' key is all table colum names" do
          @columns.map{ |h| h[:name] }.should == ["id", "name", "sex", "profile_comment", "level", "exp", "guild_id", "hp", "mp", "max_hp", "max_mp", "attack", "defence", "base_attack", "base_defence", "created_at", "updated_at"]
        end
        it "Hash 'type' key is all table colum type" do
          @columns.map{ |h| h[:type] }.first.should == :integer
        end
      end
      context "minus column option is setted" do
        before do
          @columns = Flextures::Dumper.dump_attributes User, { minus: ["id", "name", "sex", "profile_comment", "level", "exp", "guild_id", "hp"] }
        end
        it "Hash 'name' key is all table colum names" do
          @columns.map{ |h| h[:name] }.should == ["mp", "max_hp", "max_mp", "attack", "defence", "base_attack", "base_defence", "created_at", "updated_at"]
        end
      end
      context "plus column option is setted" do
        before do
          @columns = Flextures::Dumper.dump_attributes User, { plus: %W[hoge mage] }
        end
        it "Hash 'name' is added new column data" do
          @columns.map{ |h| h[:name] }.include?("hoge").should be_true
        end
      end
    end
  end
end
