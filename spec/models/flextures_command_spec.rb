require 'spec_helper'
require "fileutils"

describe Flextures::Rake::Command do
  describe "rake db::flextures::dump" do
    before do
      `rm spec/fixtures/* 2>/dev/null`
      `cp spec/fixtures_bkup2/* spec/fixtures/ 2>/dev/null`
    end

    context "not exist FORMAT option" do
      context "if set TABLE option" do
        it "file name is returned by table_name" do
          ENV["TABLE"] = "users"
          filenames = Flextures::Rake::Command::dump
          filenames.should == ["spec/fixtures/users.csv"]
          ENV.delete "TABLE"
        end
      end
      context "not setted TABLE option" do
        it " all file is returned " do
          filenames = Flextures::Rake::Command::dump
          filenames.should == ["spec/fixtures/admin_users.csv", "spec/fixtures/guilds.csv", "spec/fixtures/items.csv",
                               "spec/fixtures/s_user.csv", "spec/fixtures/upload_images.csv", "spec/fixtures/users.csv"]
        end
      end
    end

    context "FORMAT=csv" do
      context "if set TABLE option" do
        it " file name is retuned by table_name " do
          ENV["TABLE"] = "users"
          ENV["FORMAT"] = "csv"
          filenames = Flextures::Rake::Command::dump
          filenames.should == ["spec/fixtures/users.csv"]
          ENV.delete "TABLE"
          ENV.delete "FORMAT"
        end
      end
      context "not setted TABLE option" do
        it " all file is retuened " do
          ENV["FORMAT"]="csv"
          filenames = Flextures::Rake::Command::dump
          filenames.should ==  ["spec/fixtures/admin_users.csv", "spec/fixtures/guilds.csv", "spec/fixtures/items.csv",
                                "spec/fixtures/s_user.csv", "spec/fixtures/upload_images.csv", "spec/fixtures/users.csv"]
          ENV.delete "FORMAT"
        end
      end
    end

    context "FORMAT=yml" do
      context "if set TABLE option" do
        it " file name is retuned by table_name " do
          ENV["TABLE"] = "users"
          ENV["FORMAT"] = "yml"
          filenames = Flextures::Rake::Command::dump
          filenames.should == ["spec/fixtures/users.yml"]
          ENV.delete "TABLE"
          ENV.delete "FORMAT"
        end
      end
      context "not setted TABLE option" do
        it " all file is retuened " do
          ENV["FORMAT"] = "yml"
          filenames = Flextures::Rake::Command::dump
          filenames.should == ["spec/fixtures/admin_users.yml", "spec/fixtures/guilds.yml", "spec/fixtures/items.yml",
                               "spec/fixtures/s_user.yml", "spec/fixtures/upload_images.yml", "spec/fixtures/users.yml"]
          ENV.delete "FORMAT"
        end
      end
    end
    after do
      `rm spec/fixtures/* 2>/dev/null`
      `cp spec/fixtures_bkup2/* spec/fixtures/ 2>/dev/null`
    end
  end

  describe "rake db::flextures::dump" do
    context "FORMAT option is not exist" do
      context "if TABLE option is setted" do
        it " file name list will return only one file " do
          ENV["TABLE"] = "users"
          filenames = Flextures::Rake::Command::load
          filenames.should == ["spec/fixtures/users.yml"]
          ENV.delete "TABLE"
        end
      end
      context "if TABLE option is not setted" do
        it " file name list will return all table names " do
          filenames = Flextures::Rake::Command::load
          filenames.should == [ "spec/fixtures/admin_users.csv", "spec/fixtures/guilds.csv", "spec/fixtures/items.yml",
                                "spec/fixtures/s_user.csv", "spec/fixtures/upload_images.csv", "spec/fixtures/users.yml" ]
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
    end
  end
end
