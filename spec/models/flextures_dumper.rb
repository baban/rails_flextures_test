# encoding: utf-8

require 'spec_helper'
require "fileutils"

describe Flextures do
  describe "Dumper::" do
    before do
      `rm spec/fixtures/users.csv`
      `rm spec/fixtures/users.yml`
    end

    #  dumpしたデータを比較する
    describe "csv " do
=begin
      before do
        `cp spec/fixtures_bkup/users_dump.csv spec/fixtures/users.csv`
      end

      describe do
        fixtures :users

        it "はデータをdumpする" do
          @base = IO.read Rails.root.to_path<< "/spec/fixtures/users.csv"
          Flextures::Dumper::csv table: "users"
          @result = IO.read Rails.root.to_path<< "/spec/fixtures/users.csv"
          @base.should == @result
        end
      end

      after do
        `rm spec/fixtures/users.csv`
      end
=end
    end

    # dumpしたyamlを比較する
    describe "yml " do
      describe "通常テキスト" do
        before do
          FileUtils.cp "spec/fixtures_bkup/users_dump.yml", "spec/fixtures/users.yml"
        end
=begin
        describe do
          fixtures :users
          it "はyamlでデータを吐き出す" do
            @base = IO.read Rails.root.to_path<< "/spec/fixtures_bkup/users_dump.yml"
            p User.all
            Flextures::Dumper::yml table: "users"
            @result = IO.read Rails.root.to_path<< "/spec/fixtures/users.yml"
            @result.should == @base
          end
        end

        it "改行混じり" do
        end

        it "先頭space" do
        end

        it "tab混じり" do
        end

        it "" do
        end
=end
      end
    end
  end
end

