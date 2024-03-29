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
    it { should_not have_selector('title', :text => "| Home") }
    it { should have_selector('title', text: full_title('')) }

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end 

      it "should render the user's feed" do
        user.feed.each do |item|
          page.should have_selector("li##{item.id}", text: item.content)
        end
      end
    end

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
