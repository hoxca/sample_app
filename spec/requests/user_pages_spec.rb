require 'spec_helper'
require './spec/support/utilities.rb'

describe "UserPages" do
  subject { page }

  describe "signup page" do
    before do
      visit signup_path
    end

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
        it { should have_link('Sign out') }
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

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before { 
      sign_in user
      visit edit_user_path(user) 
    }

    describe "page" do
      it { should have_selector('h1',    text: "Update your profile") }
      it { should have_selector('title', text: "Edit user") }
      it { should have_link('change',    href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_common_name)  { "New Name" }
      let(:new_nickname)     { "New Nickname" }
      let(:new_email)        { "new@example.com" }
      before do
        fill_in "Common name",      with: new_common_name
        fill_in "Nickname",         with: new_nickname
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirmation",     with: user.password
        click_button "Save changes"
      end

      it { should have_selector('title', text: new_nickname) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { user.reload.common_name.should  == new_common_name }
      specify { user.reload.email.should == new_email }
    end

 end

  describe "index" do
    let(:user) { FactoryGirl.create(:user) }
    
    before(:all) { 30.times { FactoryGirl.create(:user) }  }
    after(:all) { User.delete_all }

    before(:each) do
      sign_in user
      visit users_path
    end

    it { should have_selector('title', text: 'All users') }
    it { should have_selector('h1',    text: 'All users') }

#     it "should list each user" do
#       User.all.each do |user|
#         page.should have_selector('li', text: user.common_name)
#       end
#     end

    describe "pagination" do
      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1, per_page: 5).each do |user|
          page.should have_selector('li', text: user.common_name)
        end
      end

    end

    describe "delete links" do
      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }

        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect { click_link('delete') }.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end

  end

end
