class WebHook < ActiveRecord::Base
  attr_accessible :active, :feed_id, :url

  belongs_to :feed

  validates_presence_of :url
end
