class Event < ActiveRecord::Base
  attr_accessible :entry_id, :response, :type, :web_hook_id

  belongs_to :web_hook
  belongs_to :entry
end
