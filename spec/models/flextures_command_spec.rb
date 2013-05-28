# encoding: utf-8

require 'spec_helper'
require "fileutils"

describe Flextures::Rake::Command do
  context "データダンプ関連" do
    before do
      `rm spec/fixtures/* 2>/dev/null`
      `cp spec/fixtures_bkup2/* spec/fixtures/ 2>/dev/null`
    end

    describe "::dump" do
      context "FORMAT指定なし" do
        context "テーブル名で絞ってある" do
          it " TABLE=テーブル名 を設定している場合 " do
            ENV["TABLE"] = "users"
            filenames = Flextures::Rake::Command::dump
            filenames.should == ["spec/fixtures/users.csv"]
            ENV.delete "TABLE"
          end
        end
        context "全件吐き出し" do
          it " TABLE=テーブル名 を設定している場合 " do
            filenames = Flextures::Rake::Command::dump
            filenames.should ==  ["spec/fixtures/admin_users.csv", "spec/fixtures/guilds.csv", "spec/fixtures/items.csv",
                                  "spec/fixtures/s_user.csv", "spec/fixtures/upload_images.csv", "spec/fixtures/users.csv"]
          end
        end
      end

      context "FORMAT=csv" do
        context "テーブル名で絞ってある" do
          it " TABLE=テーブル名 を設定している場合 " do
            ENV["TABLE"] = "users"
            ENV["FORMAT"] = "csv"
            filenames = Flextures::Rake::Command::dump
            filenames.should == ["spec/fixtures/users.csv"]
            ENV.delete "TABLE"
            ENV.delete "FORMAT"
          end
        end
        context "全件吐き出し" do
          it " TABLE=テーブル名 を設定している場合 " do
            ENV["FORMAT"]="csv"
            filenames = Flextures::Rake::Command::dump
            filenames.should ==  ["spec/fixtures/admin_users.csv", "spec/fixtures/guilds.csv", "spec/fixtures/items.csv",
                                  "spec/fixtures/s_user.csv", "spec/fixtures/upload_images.csv", "spec/fixtures/users.csv"]
            ENV.delete "FORMAT"
          end
        end
      end

      context "FORMAT=yml" do
        context "テーブル名で絞ってある" do
          it " TABLE=テーブル名 を設定している場合 " do
            ENV["TABLE"] = "users"
            ENV["FORMAT"] = "yml"
            filenames = Flextures::Rake::Command::dump
            filenames.should == ["spec/fixtures/users.yml"]
            ENV.delete "TABLE"
            ENV.delete "FORMAT"
          end
        end
        context "全件吐き出し" do
          it " TABLE=テーブル名 を設定している場合 " do
            ENV["FORMAT"] = "yml"
            filenames = Flextures::Rake::Command::dump
            filenames.should == ["spec/fixtures/admin_users.yml", "spec/fixtures/guilds.yml", "spec/fixtures/items.yml", 
                                 "spec/fixtures/s_user.yml", "spec/fixtures/upload_images.yml", "spec/fixtures/users.yml"]
            ENV.delete "FORMAT"
          end
        end
      end
    end

    after do
      `rm spec/fixtures/* 2>/dev/null`
      `cp spec/fixtures_bkup2/* spec/fixtures/ 2>/dev/null`
    end
  end

  context "データロード関連" do
    describe "::load" do
      context "FORMAT指定なし" do
        context "テーブル名で絞ってLoad" do
          it " TABLE=テーブル名 を設定している場合 " do
            ENV["TABLE"] = "users"
            filenames = Flextures::Rake::Command::load
            filenames.should == ["spec/fixtures/users.yml"]
            ENV.delete "TABLE"
          end
        end
        context "全件Load" do
          it "" do
            filenames = Flextures::Rake::Command::load
            filenames.should == [ "spec/fixtures/admin_users.csv", "spec/fixtures/guilds.csv", "spec/fixtures/items.yml",
                                  "spec/fixtures/s_user.csv", "spec/fixtures/upload_images.csv", "spec/fixtures/users.yml" ]
          end
        end
      end
    end

    context "FORMAT=csv" do
      context "テーブル名で絞ってLoad" do
        it " TABLE=テーブル名 を設定している場合 " do
          ENV["TABLE"] = "users"
          ENV["FORMAT"] = "csv"
          filenames = Flextures::Rake::Command::load
          ENV.delete "TABLE"
          ENV.delete "FORMAT"
        end
      end

      context "全件Load" do
        it "読めなかったFileはnilで返す" do
          ENV["FORMAT"]="csv"
          filenames = Flextures::Rake::Command::load
          filenames.should == ["spec/fixtures/admin_users.csv","spec/fixtures/guilds.csv", nil, "spec/fixtures/s_user.csv", "spec/fixtures/upload_images.csv", nil]
          ENV.delete "FORMAT"
        end
      end
    end

    context "FORMAT=yml" do
      context "テーブル名で絞ってLoad" do
        it " TABLE=テーブル名 で１つ設定 " do
          ENV["TABLE"] = "users"
          ENV["FORMAT"] = "yml"
          filenames = Flextures::Rake::Command::load
          filenames.should == ["spec/fixtures/users.yml"]
          ENV.delete "TABLE"
          ENV.delete "FORMAT"
        end

        it " 複数テーブル名前を設定 " do
          ENV["TABLE"] = "users,items"
          ENV["FORMAT"] = "yml"
          filenames = Flextures::Rake::Command::load
          filenames.should == ["spec/fixtures/users.yml","spec/fixtures/items.yml"]
          ENV.delete "TABLE"
          ENV.delete "FORMAT"
        end
      end

      context "全件Load" do
        it "読み込まないテーブルはファイル名を持たないでnil" do
          filenames = Flextures::Rake::Command::load
          filenames.should == [
            nil,
            "spec/fixtures/guilds.yml",
            "spec/fixtures/items.yml",
            nil,
            nil,
            "spec/fixtures/users.yml"
          ]
        end
      end
    end
  end
end

