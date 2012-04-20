# encoding: utf-8

require 'spec_helper'
require "fileutils"

describe Flextures::Rake::Command do
  context "データダンプ関連" do
    before do
      `rm spec/fixtures/users.csv 2>/dev/null`
      `cp spec/fixtures_bkup/users_dump.yml spec/fixtures/users.yml`
    end
    describe "::dump" do
      context "テーブル名で絞ってある" do
        it " TABLE=テーブル名 を設定している場合 " do
          ENV["TABLE"] = "users"
          Flextures::Rake::Command::dump
        end
      end
      context "全件吐き出し" do
      end
    end
    describe "::csvdump" do
      context "テーブル名で絞ってある" do
        it " TABLE=テーブル名 を設定している場合 " do
          ENV["TABLE"] = "users"
          Flextures::Rake::Command::csvdump
        end
      end
    end
    describe "::ymldump" do
      context "テーブル名で絞ってある" do
        it " TABLE=テーブル名 を設定している場合 " do
          ENV["TABLE"] = "users"
          #Flextures::Rake::Command::ymldump
        end
      end
    end
    after do
      `rm spec/fixtures/users.csv 2>/dev/null`
    end
  end

  context "データロード" do
    describe "::load" do
      context "テーブル名で絞ってLoad" do
        it " TABLE=テーブル名 を設定している場合 " do
          ENV["TABLE"] = "users"
          Flextures::Rake::Command::load
        end
      end
      context "全件Load" do
      end
    end
    describe "::csvload" do
      context "テーブル名で絞ってLoad" do
        it " TABLE=テーブル名 を設定している場合 " do
          ENV["TABLE"] = "users"
          # Flextures::Rake::Command::csvload
        end
      end
      context "全件Load" do
      end
    end
    describe "::ymlload" do
      context "テーブル名で絞ってLoad" do
        it " TABLE=テーブル名 を設定している場合 " do
          ENV["TABLE"] = "users"
          filenames = Flextures::Rake::Command::ymlload
          filenames.should == ["spec/fixtures/users.yml"]
        end
        it " TABLE=テーブル名 を設定している場合 " do
          ENV["TABLE"] = "users,items"
          filenames = Flextures::Rake::Command::ymlload
          filenames.should == ["spec/fixtures/users.yml","spec/fixtures/items.yml"]
        end
      end
      context "全件Load" do
      end
    end
  end
end

