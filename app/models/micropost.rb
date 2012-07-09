class Micropost < ActiveRecord::Base
  attr_accessible :content
  belongs_to :user

  default_scope order: 'microposts.created_at DESC'

  validates :content, :user_id, presence: true
  validates_length_of :content, :maximum => 140, :message => "Micropost must not exceed 140 characters"

end
