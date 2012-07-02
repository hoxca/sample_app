require 'spec_helper'
require './spec/support/utilities.rb'

describe "UserPages" do
  subject { page }

  describe "signup page" do
    before { visit signup_path }

    it { should have_selector('h1', text: 'Sign Up') }
    it { should have_selector('title', text: full_title('Sign Up')) }
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_selector('h1',    text: user.common_name) }
    it { should have_selector('title', text: user.nickname) }
  end  

  describe "signup" do
    before do
      visit signup_path
      fill_in "Nickname",     with: "nick"
      fill_in "Common name",  with: "Example User"
      fill_in "First name",   with: "Example"
      fill_in "Last name",    with: "User"
      fill_in "Email",        with: "user@example.com"
      fill_in "Password",     with: "foobar"
      fill_in "Confirmation", with: "foobar"
    end 

    let(:submit) { "Create my account" }

    describe "should not add user with invalid information" do
      before do
        fill_in "Nickname",     with: " "
      end
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "should show error after invalid submission" do
        before do 
          fill_in "Nickname",     with: " "
          click_button submit
        end

        it { should have_selector('title', text: 'Sign Up') }
        it { should have_content('error') }
    end

    describe "should create user with valid information" do
      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end

    describe "should welcome a new user" do
      before { click_button submit }
        it { should have_selector('title', text: 'nick') }
        it { should have_selector('div.alert.alert-success', text: "Welcome to the Sample App!") }
    end

    describe "should not raise sql exception with duplicate email" do
      it "should show a warning 'Email already taken'" do
        click_button submit
        visit signup_path
        fill_in "Nickname",     with: "nick2"
        fill_in "Common name",  with: "Example User2"
        fill_in "First name",   with: "Example2"
        fill_in "Last name",    with: "User2"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar2"
        fill_in "Confirmation", with: "foobar2"

        expect { click_button submit }.should_not raise_error
        should have_content('Email address already taken from another account !') 
      end
    end

  end

end
