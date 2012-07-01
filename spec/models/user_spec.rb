# == Schema Information
#
# Table name: users
#
#  id          :integer         not null, primary key
#  nickname    :string(255)
#  email       :string(255)
#  common_name :string(255)
#  first_name  :string(255)
#  last_name   :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

require 'spec_helper'

describe "User:" do
  context "Should not validate user data" do
    before { @user = User.new(nickname:"Hoxca", email:"hugh@atosc.org", common_name:"Hugues Obolonsky", first_name:"Hugues", last_name:"Obolonsky", password: "pwd42aaa", password_confirmation:"pwd42aaa") }
    subject { @user }

    respond = ["common_name","nickname","email","first_name","last_name","password","password_confirmation","password_digest","authenticate"]
    attributes = ["common_name","nickname","email","first_name","last_name","password","password_confirmation"]

    it { should be_valid }

    respond.each do |attrname|
      it { should respond_to(attrname.to_sym) }
    end

    attributes.each do |attrname|
      describe "when #{attrname} is not present" do
        before { eval("@user.#{attrname} = ' '") }
        it { should_not be_valid }
      end
    end

    describe "when name is too long" do
      before { @user.common_name = "a" * 51 }
      it { should_not be_valid }
    end

    describe "when first_name is too long" do
      before { @user.first_name = "a" * 31 }
      it { should_not be_valid }
    end

    describe "when last_name is too long" do
      before { @user.last_name = "a" * 31 }
      it { should_not be_valid }
    end

    describe "when password doesn't match confirmation" do
      before { @user.password_confirmation = "mismatch" }
      it { should_not be_valid }
    end

    describe "when password confirmation is nil" do
      before { @user.password_confirmation = nil }
      it { should_not be_valid }
    end

    describe "with a password that's too short" do
      before { @user.password = @user.password_confirmation = "a" * 5 }
      it { should be_invalid }
    end

    describe "when email format is invalid" do
      it "should be invalid" do
        addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
        addresses.each do |invalid_address|
          @user.email = invalid_address
          @user.should_not be_valid
        end      
      end
    end

    describe "except when we provide a valid email format" do
      it "then it should be valid" do
        addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
        addresses.each do |valid_address|
          @user.email = valid_address
          @user.should be_valid
        end      
      end
    end
  end

  context "Create user" do
    describe "when email address is already taken" do
      before {
       @user = User.create(nickname: "Hoxca", email: "hugh@atosc.org", common_name:"Hugues Obolonsky", first_name:"Hugues",last_name:"Obolonsky",password: "pwd42aaa", password_confirmation:"pwd42aaa")
      }
      it "then it should not save duplicates" do
        expect { User.create(nickname: "User", email: "hugh@atosc.org", common_name: "User with Same Address", first_name:"User",last_name:"Same Address",password: "pwd42aaa", password_confirmation:"pwd42aaa") }.should raise_error
      end
      it "then it should not save even if the case is different" do
        expect { User.create(nickname: "User", email: "huGh@atosc.org", common_name: "User with Same Address", first_name:"User",last_name:"Same Address",password: "pwd42aaa", password_confirmation:"pwd42aaa") }.should raise_error
      end
    end
  end  

  context "Authenticate" do
    before { @user = User.new(nickname:"Hoxca", email:"hugh@atosc.org", common_name:"Hugues Obolonsky", first_name:"Hugues", last_name:"Obolonsky", password: "pwd42aaa", password_confirmation:"pwd42aaa") }
    subject { @user }
    describe "return value of authenticate method" do
      before { @user.save }
      let(:found_user) { User.find_by_email(@user.email) }

      describe "with valid password" do
        it { should == found_user.authenticate(@user.password) }
      end

      describe "with invalid password" do
        let(:user_for_invalid_password) { found_user.authenticate("invalid") }

        it { should_not == user_for_invalid_password }
        specify { user_for_invalid_password.should be_false }
      end
    end
  end

end
