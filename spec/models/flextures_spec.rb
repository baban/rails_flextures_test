require 'spec_helper'

describe Flextures do
# Idea:
# * Support minitest
# * FactoryGirl support
  describe "ARGS::parse" do
    context "when option is empty" do
      before do
        @format = Flextures::ARGS.parse({})
      end

      it " get all table name data " do
        @format.size.should == ActiveRecord::Base.connection.tables.size - 1
      end
    end

    context "when MODEL option is exist" do
      subject do
        Flextures::ARGS.parse("MODEL" => "User")
      end

      it "table information is equal model data" do
        subject.first[:table].should == "users"
      end
    end

    context "when M option is exist" do
      before do
        @format = Flextures::ARGS.parse("M" => "User")
      end

      it "table information is equal model data" do
        @format.first[:table].should == "users"
      end
    end

    context "when DIR option is exist" do
      before do
        @format = Flextures::ARGS.parse("M"=>"User", "DIR"=>"test/fixtures/")
      end

      it "dump directrory information is changed" do
        @format.first[:dir].should == "test/fixtures/"
      end
    end

    context "when D option is exist" do
      before do
        @format = Flextures::ARGS.parse("M"=>"User", "D"=>"test/fixtures/")
      end

      it "dump directrory information is changed" do
        @format.first[:dir].should == "test/fixtures/"
      end
    end

    context "when FIXTURES options is includeed" do
      it " FIXTURES=でもダンプするファイルを変更できる " do
        format = Flextures::ARGS.parse("M"=>"User", "FIXTURES"=>"user_another")
        expect(format.first[:table]).to eq "users"
        expect(format.first[:file]).to eq "user_another"
      end

      it " FIXTURES=でもダンプするファイルを変更できる " do
        format = Flextures::ARGS.parse("FIXTURES" => "users,items")
        format[0][:table].should == "users"
        format[0][:file].should == "users"
        format[1][:table].should == "items"
        format[1][:file].should == "items"
      end
    end

    context "when MINUS options is includeed" do
      before do
        @format = Flextures::ARGS.parse("TABLE"=>"users", "MINUS"=>"created_at")
      end

      it "minus colum option is exist" do
        @format.first[:minus].should be_instance_of Array
      end

      it "minus colum option is exist" do
        @format.first[:minus].should == ["created_at"]
      end
    end

    context "when PLUS options is includeed" do
      before do
        @format = Flextures::ARGS.parse("TABLE"=>"users", "PLUS"=>"hoge")
      end

      it "minus colum option is exist" do
        @format.first[:plus].should be_instance_of Array
      end

      it "minus colum option is exist" do
        @format.first[:plus].should == ["hoge"]
      end
    end

    context "when OPTIONS options is includeed" do
      context "OPTION include 'silent' value" do
        before do
          @format = Flextures::ARGS.parse("TABLE"=>"users", "OPTION"=>"silent")
        end

        it "minus colum option is exist" do
          @format.first[:silent].should be true
        end
      end

      context "OPTION include 'unfilter' value" do
        before do
          @format = Flextures::ARGS.parse("TABLE"=>"users", "OPTION"=>"unfilter")
        end

        it "minus colum option is exist" do
          @format.first[:unfilter].should be true
        end
      end

      context "OPTION include 'strict' value" do
        before do
          @format = Flextures::ARGS.parse("TABLE"=>"users", "OPTION"=>"strict")
        end

        it "minus colum option is exist" do
          @format.first[:strict].should be true
        end
      end
    end
  end

  describe "ARGS::exist" do
    context "file is only one" do
      it "file is exist" do
        files = ["users"]
        files.select(&Flextures::ARGS.exist).should == files
      end
    end

    context "many file names" do
      it "squueze exist files" do
        files = ["users", "fake_file"]
        files.select(&Flextures::ARGS.exist).should == ["users"]
      end
    end
  end

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
