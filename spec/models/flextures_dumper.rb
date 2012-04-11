# encoding: utf-8

require 'spec_helper'
require "fileutils"

describe Flextures do
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
      end
    end
    after do
      `rm spec/fixtures/users.csv 2>/dev/null`
      `rm spec/fixtures/users.yml 2>/dev/null`
      FileUtils.cp "spec/fixtures_bkup/users_dump.yml", "spec/fixtures/users.yml"
    end
  end
end

