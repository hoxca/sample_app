require 'spec_helper'

describe "StaticPages" do
  describe "GET /static_pages" do
    it "works! (now write some real specs)" do
      get static_pages_home_path
      response.status.should be(200)
    end
  
    it "should have the content 'Sample App'" do
      visit '/static_pages/home'
      page.should have_content('You are on the Rails Tutorial')
    end

    it "should have the right title" do
      visit '/static_pages/home'
      page.should have_selector('title',
                                :text => "Tutorial Sample App | Home")
    end
  end

  describe "Help page" do
    it "works! (now write some real specs)" do
      get static_pages_help_path
      response.status.should be(200)
    end
  
    it "should have the content 'Help'" do
      visit '/static_pages/help'
      page.should have_content('Get help on the Ruby')
    end

    it "should have the title 'Help'" do
         visit '/static_pages/help'
         page.should have_selector('title', 
                                   :text => "Tutorial Sample App | Help")
    end
  end

  describe "About page" do
    it "should have the content 'About Us'" do
      visit '/static_pages/about'
      page.should have_content('We are legion')
    end

    it "should have the title 'About'" do
         visit '/static_pages/about'
         page.should have_selector('title', 
                                   :text => "Tutorial Sample App | About")
    end
   end

end 
