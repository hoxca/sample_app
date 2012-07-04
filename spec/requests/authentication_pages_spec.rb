require 'spec_helper'
require './spec/support/utilities.rb'

describe "Authentication" do

  describe "Session routes" do
    it "should respond to new" do
      get signin_path 
      response.status.should be(200)
    end

    it "should respond to destroy" do
      get signout_path 
      response.status.should be(302)
    end

  end

  describe "Session create" do
    it "should respond to create method" do
      s = SessionsController.new
      s.should respond_to(:create)
    end
  end

  subject { page }
  describe "signin page" do
    before { visit signin_path }

    it { should have_selector('h1',    text: 'Sign in') }
    it { should have_selector('title', text: 'Sign in') }
  end

  describe "signin" do
    before { visit signin_path }

    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_selector('title', text: 'Sign in') }
      it { should have_selector('div.alert.alert-error', text: 'Invalid') }

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end

    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }      

      it { should have_selector('title', text: user.nickname) }
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Settings', href: edit_user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }

      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link('Sign In') }
      end

    end 
 
  end

end

