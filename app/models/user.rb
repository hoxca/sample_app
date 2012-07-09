# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  nickname        :string(255)
#  email           :string(255)
#  common_name     :string(255)
#  first_name      :string(255)
#  last_name       :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean
#

class User < ActiveRecord::Base
  attr_accessible :common_name, :email, :first_name, :last_name, :nickname,
                  :password, :password_confirmation

  has_secure_password
  has_many :microposts, dependent: :destroy


  validates :common_name, :email, :first_name, :last_name, :nickname,  presence: true
  validates :common_name, length: { maximum: 50 }
  validates :first_name, length: { maximum: 30 }
  validates :last_name, length: { maximum: 30 }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, format: { with: VALID_EMAIL_REGEX } 

  before_save { self.email.downcase! }
  before_save :create_remember_token

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

end
