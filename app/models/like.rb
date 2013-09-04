class Like < ActiveRecord::Base
  attr_accessible :user
  
  belongs_to :user
  belongs_to :likeable, polymorphic: true
end
