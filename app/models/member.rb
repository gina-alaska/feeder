class Member < ActiveRecord::Base
  # attr_accessible :admin, :email, :name

  has_many :users

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
