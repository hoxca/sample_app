require 'spec_helper'

describe "StaticPages" do

  let(:base_title) { "Tutorial Sample App |"}

  describe "all pages routing should return 200" do

    it "works! (now write some real specs)" do
      page_list = ["home","help","about","contact"]
      page_list.each do |page| 
        get "/static_pages/#{page}"
        response.status.should be(200)
      end
    end

  end 

  describe "GET /static_pages" do
    before(:each) do
      visit '/static_pages/home'
    end

    it "should have the content 'Sample App'" do
      page.should have_content('You are on the Rails Tutorial')
    end

    it "should have the right title" do
      page.should have_selector('title',
                                :text => "#{base_title} Home")
    end
  end

  describe "Help page" do
    before(:each) do
      visit '/static_pages/help'
    end
  
    it "should have the content 'Help'" do
      page.should have_content('Get help on the Ruby')
    end

    it "should have the title 'Help'" do
      page.should have_selector('title', 
                                :text => "#{base_title} Help")
    end
  end

  describe "About page" do
    before(:each) do
      visit '/static_pages/about'
    end

    it "should have the content 'About Us'" do
      page.should have_content('We are legion')
    end

    it "should have the title 'About'" do
      page.should have_selector('title', 
                                :text => "#{base_title} About")
    end
   end

  describe "Contact page" do
    before(:each) do
      visit '/static_pages/contact'
    end

    it "should have the content 'Contact Ruby on Rails'" do
      page.should have_content('Contact Ruby on Rails')
    end

    it "should have the title 'Contact'" do
      page.should have_selector('title',
                                :text => "#{base_title} Contact" )
    end

  end

end 
