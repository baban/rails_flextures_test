require 'spec_helper'

describe Flextures do
  describe "Loader::" do
    describe "::file_exist " do
      context "only csv files" do
        before do
          @file_name, @ext, @erb = Flextures::Loader::file_exist(table:'users', file:"onlycsv")
        end

        it "return csv file name" do
          @file_name.should=="spec/fixtures/onlycsv.csv"
        end

        it "return csv format option" do
          @ext.should==:csv
        end
      end

      context "only yaml files" do
        before do
          @file_name, @ext, @erb = Flextures::Loader::file_exist(table:'users', file:"onlyyaml")
        end

        it "return yaml file name" do
          @file_name.should=="spec/fixtures/onlyyaml.yml"
        end

        it "return yml format option" do
          @ext.should==:yml
        end
      end

      context "exist both files(yaml and csv)" do
        before do
          @file_name, @ext, @erb = Flextures::Loader::file_exist(table:'users', file:"bothexist")
        end

        it "return csv file name" do
          @file_name.should=="spec/fixtures/bothexist.csv"
        end

        it "return yml format option" do
          @ext.should==:csv
        end
      end

      context "not exist both files (yaml and csv)" do
        before do
          @file_name, @ext, @erb = Flextures::Loader::file_exist(table:'users', file:"notexist")
        end

        it "return 'nil' value" do
          @file_name.should be nil
        end

        it "return nil format option" do
          @ext.should be nil
        end
      end

      context "exist erb.csv file" do
        before do
          @file_name, *@ext = Flextures::Loader::file_exist(table:'users', file:"users_erb")
        end

        it "return 'nil' value" do
          @file_name.should == "spec/fixtures/users_erb.erb.csv"
        end

        it "return nil format option" do
          @ext.should == [:erb, :csv]
        end
      end

      context "set dir option" do
        before do
          @file_name, *@ext = Flextures::Loader::file_exist(table:'users', dir:"hoge")
        end

        it "return under dir option directory file name" do
          @file_name.should == "spec/fixtures/hoge/users.csv"
        end

        it "return 'nil' type" do
          @ext.should == [:csv]
        end
      end

      context " set stair option " do
        before do
          @file_name, @ext, @erb = Flextures::Loader::file_exist(table:'users', dir:"hoge/mage/fuga", stair: true)
        end

        it "return under dir option directory file name" do
          @file_name.should == "spec/fixtures/hoge/users.csv"
        end

        it "return 'nil' type" do
          @ext.should == :csv
        end
      end
    end

    describe "::load " do
      before do
        `rm spec/fixtures/users.csv 2>/dev/null`
        `rm spec/fixtures/users.yml 2>/dev/null`
        `cp spec/fixtures_bkup/users_load.csv spec/fixtures/users.csv`
        `cp spec/fixtures_bkup/users_load.yml spec/fixtures/users.yml`
      end

      before do
        User.delete_all
      end

      it "load file prefer to csv file" do
        Flextures::Loader::load table: "users"
        User.first.id.should == 1
      end

      it "if 'file: filename' option is exist. load this file" do
        method = Flextures::Loader::load table: "users", file: "user_another2"
        User.first.name.should == 'ggg'
      end
    end

    describe "::csv " do
      before do
        `rm spec/fixtures/users.csv 2>/dev/null`
        `rm spec/fixtures/users.yml 2>/dev/null`
        `cp spec/fixtures_bkup/users_load.csv spec/fixtures/users.csv`
      end

      before do
        User.delete_all
      end

      it "load default data" do
        User.delete_all
        Flextures::Loader::csv table: "users"
        User.first.id.should == 1
      end

      it "load data (overfolow columns delete)" do
        `cp spec/fixtures/guilds_column_add.csv spec/fixtures/guilds.csv`
        klass = Class.new(ActiveRecord::Base){ |o| o.table_name="guilds" }
        klass.delete_all
        Flextures::Loader::csv table: "guilds"
        klass.first.id.should == 1
        `cp spec/fixtures_bkup/guilds.csv spec/fixtures/`
      end

      it "load data add lack columns" do
        `cp spec/fixtures/guilds_column_dec.csv spec/fixtures/guilds.csv`
        klass = Class.new(ActiveRecord::Base){ |o| o.table_name="guilds" }
        Flextures::Loader::csv table: "guilds"
        klass.first.id.should == 1
        `cp spec/fixtures_bkup/guilds.csv spec/fixtures/`
      end

      it " if file: 'filename' option exist, csv load that file" do
        klass = Class.new(ActiveRecord::Base){ |o| o.table_name= "users" }
        Flextures::Loader::csv table: "users", file: "user_another"
        klass.first.id == 1
      end

      after do
        User.delete_all
      end
    end

    describe "::yml" do
      before do
        `rm spec/fixtures/users.csv 2>/dev/null`
        `rm spec/fixtures/users.yml 2>/dev/null`
        `cp spec/fixtures_bkup/users_load.yml spec/fixtures/users.yml`
      end

      before do
        User.delete_all
      end

      it "loda table size is 1" do
        Flextures::Loader::yml table: "users"
        User.first.id.should == 1
      end

      it " if file: 'filename' option exist, csv load that file" do
        klass = Class.new(ActiveRecord::Base){ |o| o.table_name= "users" }
        Flextures::Loader::yml table: "users", file: "user_another"
        klass.first.name.should == 'jjj'
      end
    end
  end
end
