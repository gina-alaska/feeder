class Authorization < ActiveRecord::Base
  belongs_to :user
  
  attr_accessible :provider, :uid, :user_id, :user
  
  validates_presence_of :user_id, :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider
  
  def self.find_from_hash(hash)
    auth = where(provider: hash['provider'], uid: hash['uid']).first
    if auth.try(:user).nil?
      auth.try(:destroy)
      return nil
    end
    
    auth
  end

  def self.create_from_hash(hash, user = nil)
    user ||= User.create_from_hash!(hash)
    Authorization.create(:user => user, :uid => hash['uid'], :provider => hash['provider'])
  end
end
