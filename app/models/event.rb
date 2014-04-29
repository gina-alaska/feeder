class Event < ActiveRecord::Base
  attr_accessible :entry_id, :response, :type, :web_hook_id

  belongs_to :web_hook
  belongs_to :entry

  def payload
    {}
  end

  def async_generate_create_event
    CreateEntryEventWorker.perform(self.id)
  end
end
