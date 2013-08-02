class User < ActiveRecord::Base
  has_many :authorizations
  belongs_to :member
  
  attr_accessible :name, :email
  
  validates_presence_of :email
  validates_uniqueness_of :email
  
  def admin?
    self.membership.admin?
  end
  
  def self.create_from_hash!(hash)
    user = create(:name => hash['info']['name'], :email => hash['info']['email'])
    
    user
  end
  
  def membership
    if self.member.nil?
      membership = Member.where(email: self.email).first
      if membership.nil?
        self.create_member(name: self.name, email: self.email)
      else
        self.member = membership
      end
    end
    self.member
  end
end
