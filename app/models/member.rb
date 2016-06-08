class Member < ActiveRecord::Base
  has_many :users

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
