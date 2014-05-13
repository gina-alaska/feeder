class WebHook < ActiveRecord::Base
  attr_accessible :active, :feed_id, :url

  belongs_to :feed
  has_many :events

  validates_presence_of :url
end
