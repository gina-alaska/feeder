class Event < ActiveRecord::Base
  attr_accessible :entry_id, :response, :type, :web_hook_id

  belongs_to :web_hook
  belongs_to :entry

  def type
    nil
  end

  def payload
    {}
  end

  def version
    "0.0.1"
  end

  def notify
    HTTParty.post(self.web_hook.url, {
      query: {
        type: self.type,
        version: self.version,
        payload: self.payload.to_json
      }
    })
  end

  def helpers
    Rails.application.routes.url_helpers
  end
end
