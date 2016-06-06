class WebHook < ActiveRecord::Base
  belongs_to :feed
  has_many :events

  validates_presence_of :url

  scope :active, -> { where(active: true) }
end
