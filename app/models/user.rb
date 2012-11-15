class User < ActiveRecord::Base
  has_many :authorizations
  
  attr_accessible :name, :email
  
  validates_presence_of :email
  validates_uniqueness_of :email
  
  def self.create_from_hash!(hash)
    create(:name => hash['info']['name'], :email => hash['info']['email'])
  end
end
