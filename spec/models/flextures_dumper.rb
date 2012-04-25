# encoding: utf-8

require 'spec_helper'
require "fileutils"

describe Flextures do
  describe "" do
    describe "TRANSLATER" do
      describe :binary do
        context :yml do
          it "null" do
            Flextures::Dumper::TRANSLATER[:binary].call( nil, :yml ).should === "null"
          end
        end
        context :csv do
        end
      end
      describe :boolean do
        context :yml do
          it "null" do
            Flextures::Dumper::TRANSLATER[:boolean].call( nil, :yml ).should === "null"
          end
          it "0" do
            Flextures::Dumper::TRANSLATER[:boolean].call( 0, :yml ).should === false
          end
          it "1" do
            Flextures::Dumper::TRANSLATER[:boolean].call( 1, :yml ).should === true
          end
          it "空文字" do
            Flextures::Dumper::TRANSLATER[:boolean].call( "", :yml ).should === false
          end
          it "文字列" do
            Flextures::Dumper::TRANSLATER[:boolean].call( "Hello", :yml ).should === true
          end
        end
        context :csv do
        end
      end
      describe :date do
        context :yml do
          it "null" do
            Flextures::Dumper::TRANSLATER[:date].call( nil, :yml ).should === "null"
          end
          it "空文字" do
            Flextures::Dumper::TRANSLATER[:date].call( "", :yml ).should === "null"
          end
          it "false" do
            Flextures::Dumper::TRANSLATER[:date].call( false, :yml ).should === "null"
          end
        end
        context :csv do
        end
      end
      describe :datetime do
        context :yml do
          it "null" do
            Flextures::Dumper::TRANSLATER[:datetime].call( nil, :yml ).should === "null"
          end
          it "空文字" do
            Flextures::Dumper::TRANSLATER[:datetime].call( "", :yml ).should === "null"
          end
          it "false" do
            Flextures::Dumper::TRANSLATER[:datetime].call( false, :yml ).should === "null"
          end
        end
        context :csv do
        end
      end
      describe :decimal do
        context :yml do
          it "null" do
            Flextures::Dumper::TRANSLATER[:decimal].call( nil, :yml ).should === "null"
          end
          it "0" do
            Flextures::Dumper::TRANSLATER[:decimal].call( 0, :yml ).should === 0
          end
          it "false" do
            Flextures::Dumper::TRANSLATER[:decimal].call( false, :yml ).should === 0
          end
        end
        context :csv do
        end
      end
      describe :float do
        context :yml do
          it "null" do
            Flextures::Dumper::TRANSLATER[:float].call( nil, :yml ).should === "null"
          end
          it "0" do
            Flextures::Dumper::TRANSLATER[:float].call( 0, :yml ).should === 0
          end
          it "false" do
            Flextures::Dumper::TRANSLATER[:float].call( false, :yml ).should === 0
          end
        end
        context :csv do
        end
      end
      describe :integer do
        context :yml do
          it "null" do
            Flextures::Dumper::TRANSLATER[:integer].call( nil, :yml ).should === "null"
          end
          it "0" do
            Flextures::Dumper::TRANSLATER[:integer].call( 0, :yml ).should === 0
          end
          it "false" do
            Flextures::Dumper::TRANSLATER[:integer].call( false, :yml ).should === 0
          end
        end
        context :csv do
        end
      end
      describe :string do
        context :yml do
          it "null" do
            Flextures::Dumper::TRANSLATER[:string].call( nil, :yml ).should === "null"
          end
          it "空文字" do
            Flextures::Dumper::TRANSLATER[:string].call( "", :yml ).should === ""
          end
          it "false" do
            Flextures::Dumper::TRANSLATER[:string].call( false, :yml ).should === false
          end
          it "配列ライク" do
            #s = "[hoge,:fsaC)]"
            #Flextures::Dumper::TRANSLATER[:string].call( s, :yml ).should === '[hoge,:fsaC)]'
          end
        end
        context :csv do
        end
      end
      describe :text do
        context :yml do
          it "null" do
            Flextures::Dumper::TRANSLATER[:string].call( nil, :yml ).should === "null"
          end
          it "空文字" do
            Flextures::Dumper::TRANSLATER[:string].call( "", :yml ).should === ""
          end
          it "false" do
            Flextures::Dumper::TRANSLATER[:string].call( false, :yml ).should === false
          end
        end
        context :csv do
        end
      end
      describe :time do
        context :yml do
          it "null" do
            Flextures::Dumper::TRANSLATER[:time].call( nil, :yml ).should === "null"
          end
          it "空文字" do
            Flextures::Dumper::TRANSLATER[:time].call( "", :yml ).should === "null"
          end
          it "false" do
            Flextures::Dumper::TRANSLATER[:time].call( false, :yml ).should === "null"
          end
        end
        context :csv do
        end
      end
      describe :timestamp do
        context :yml do
          it "null" do
            Flextures::Dumper::TRANSLATER[:time].call( nil, :yml ).should === "null"
          end
          it "空文字" do
            Flextures::Dumper::TRANSLATER[:time].call( "", :yml ).should === "null"
          end
          it "false" do
            Flextures::Dumper::TRANSLATER[:time].call( false, :yml ).should === "null"
          end
        end
        context :csv do
        end
      end
    end
  end

  describe "Dumper::" do
    before do
      `rm spec/fixtures/users.csv 2>/dev/null`
      `rm spec/fixtures/users.yml 2>/dev/null`
    end

    #  dumpしたデータを比較する
    describe "csv " do
      before do
        `cp spec/fixtures_bkup/users_dump.csv spec/fixtures/users.csv`
      end

      describe do
        flextures :users

        it "はデータをdumpする" do
          @base = IO.read Rails.root.to_path<< "/spec/fixtures/users.csv"
          Flextures::Dumper::csv table: "users"
          @result = IO.read Rails.root.to_path<< "/spec/fixtures/users.csv"
          @base.should == @result
        end
      end

      describe :null do
        before do
          User.create( name:"hoge", sex: 0, level: 1, exp: 0, guild_id: 0, hp: 10, mp: 0 )
        end
        
        it "nullをdumpする" do
          Flextures::Dumper::csv table: "users"
          path = Rails.root.to_path<< "/spec/fixtures/users.csv"
          CSV.open( path ) do |csv|
            keys = csv.shift
            values = csv.first
            values[3].should == nil
          end
        end
      end

      describe "空文字" do
        before do
          User.create( name:"hoge", sex: 0, profile_comment:"", level: 1, exp: 0, guild_id: 0, hp: 10, mp: 0 )
        end
        
        it "nullをdumpする" do
          Flextures::Dumper::csv table: "users"
          path = Rails.root.to_path<< "/spec/fixtures/users.csv"
          CSV.open( path ) do |csv|
            keys = csv.shift
            values = csv.first
            values[3].should == ""
          end
        end
      end
    end

    # dumpしたyamlを比較する
    describe "yml " do
      describe "通常テキスト" do
        before do
          FileUtils.cp "spec/fixtures_bkup/users_dump.yml", "spec/fixtures/users.yml"
        end
        describe do
          flextures :users
          it "はyamlでデータを吐き出す" do
            @base = IO.read Rails.root.to_path<< "/spec/fixtures_bkup/users_dump.yml"
            Flextures::Dumper::yml table: "users"
            @result = IO.read Rails.root.to_path<< "/spec/fixtures/users.yml"
            @result.should == @base
          end
        end

        describe "改行混じり" do
          before do
            FileUtils.cp "spec/fixtures_bkup/users_dump_br.yml", "spec/fixtures/users.yml"
          end

          context do
            flextures :users

            it "はyamlでデータを吐き出す" do
              @base = IO.read Rails.root.to_path<< "/spec/fixtures_bkup/users_dump_br.yml"
              Flextures::Dumper::yml table: "users"
              @result = IO.read Rails.root.to_path<< "/spec/fixtures/users.yml"
              @result.should == @base
            end
          end
        end

        context "null" do
          before do
            User.create( name:"hoge", sex: 0, level: 1, exp: 0, guild_id: 0, hp: 10, mp: 0 )
          end
          it "nilをnullとしてdumpする" do
            Flextures::Dumper::yml table: "users"
            yaml = YAML.load_file( Rails.root.to_path+"/spec/fixtures/users.yml" )
            yaml["users_0"]["profile_comment"].should == nil
          end
        end

        context "先頭space" do
          before do
            `rm spec/fixtures/users.csv 2>/dev/null`
            `rm spec/fixtures/users.yml 2>/dev/null`
            FileUtils.cp "spec/fixtures_bkup/users_dump_space.csv", "spec/fixtures/users.csv"
          end
          flextures :users

          it "YAMLは読み込み可能" do
            Flextures::Dumper::yml table: "users"
            expect { YAML.load_file( Rails.root.to_path+"/spec/fixtures/users.yml" ) }.not_to raise_error
          end

          it "先頭のスペースを削除した状態にする" do
            Flextures::Dumper::yml table: "users"
            yaml = YAML.load_file( Rails.root.to_path+"/spec/fixtures/users.yml" )
            yaml["users_0"]["name"].should == "bcde"
          end

          it "先頭がtabでも削除" do
            Flextures::Dumper::yml table: "users"
            yaml = YAML.load_file( Rails.root.to_path+"/spec/fixtures/users.yml" )
            yaml["users_3"]["name"].should == "llll"
            yaml["users_4"]["name"].should == "mm\nmm"
          end
        end

        context "tab混じり" do
          context "tabを２スペースに変換" do
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

        context "特殊文字" do
          let(:user){ { name:"hoge", sex: 0, level: 1, exp: 0, guild_id: 0, hp: 10, mp: 0 } }
          context "括弧" do
            before do
              @dump_method = ->{
                User.create( user )
                Flextures::Dumper::yml table: "users"
                YAML.load_file( Rails.root.to_path+"/spec/fixtures/users.yml" )
              }
              User.delete_all
            end
            ["[","]","{","}","|","#","@","~","!","'","$","&","^","<",">","?","-","+","=",";",":",".",",","*","`","(",")"].each do |c|
              "\"'"
              it c do
                user[:name] = c+"hoge"
                @dump_method.call
                yaml = @dump_method.call
                yaml["users_0"]["name"].should == user[:name]
              end
            end
          end
          # "[]{}|#@~!'\"$&^<>?//-+=;:.,*'\`()"
        end

      end
    end
    after do
      `rm spec/fixtures/users.csv 2>/dev/null`
      `rm spec/fixtures/users.yml 2>/dev/null`
      FileUtils.cp "spec/fixtures_bkup/users_dump.yml", "spec/fixtures/users.yml"
    end
  end
end

