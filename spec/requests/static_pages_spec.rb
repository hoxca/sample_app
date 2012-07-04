require 'spec_helper'

describe "StaticPages" do

  let(:base_title) { "Tutorial Sample App"}

  describe "all pages routing should return 200" do
 
    it "works! (now write some real specs)" do
      page_list = ["","help","about","contact"]
      page_list.each do |page| 
        get "/#{page}"
        response.status.should be(200)
      end
    end
 
  end 

  subject { page }

  describe "Home pages" do
    before(:each) do
      visit root_path
    end
    it { should have_content('This is the home page for') }
    it { should have_selector('title', text: full_title('')) }
    it { should_not have_selector('title', :text => "| Home") }
   end

  describe "Help page"  do
    before(:each) do
      visit help_path
    end
    it { should have_content('Get help on the Ruby') }
    it { should have_selector('title', :text => "#{base_title} | Help") }
    it { should have_selector('title', text: full_title('Help')) }
  end

  describe "About page" do
    before(:each) do
      visit about_path
    end
    it { should have_content('We are legion') }
    it { should have_selector('title', :text => "#{base_title} | About") }
    it { should have_selector('title', text: full_title('About')) }
   end

  describe "Contact"  do
    before(:each) do
      visit contact_path
    end
    it { should have_content('Contact Ruby on Rails') }
    it { should have_selector('title', :text => "#{base_title} | Contact" ) }
    it { should have_selector('title', text: full_title('Contact')) }
  end

end 
