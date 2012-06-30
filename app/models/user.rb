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
#  last_name   :string(255)

class User < ActiveRecord::Base
  attr_accessible :common_name, :email, :first_name, :last_name, :nickname

  validates :common_name, :email, :first_name, :last_name, :nickname,  presence: true
  validates :common_name, length: { maximum: 50 }
  validates :first_name, length: { maximum: 30 }
  validates :last_name, length: { maximum: 30 }
end