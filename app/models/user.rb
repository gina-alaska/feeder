class User < ActiveRecord::Base
  include UserDevise

  validates_presence_of :email
  validates_uniqueness_of :email

  # TODO: Remove and replace with CanCanCan
  def admin?
    site_admin?
  end
end
