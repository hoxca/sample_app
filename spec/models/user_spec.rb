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

describe User do
  before { @user = User.new(nickname: "Hoxca", email: "hugh@atosc.org", common_name:"Hugues Obolonsky", first_name:"Hugues",last_name:"Obolonsky") }

  subject { @user }

  attributes = ["common_name","nickname","email","first_name","last_name"]

  it { should be_valid }

  attributes.each do |attrname|
    it { should respond_to(attrname.to_sym) }
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

  describe "when name is too long" do
    before { @user.last_name = "a" * 31 }
    it { should_not be_valid }
  end

end
