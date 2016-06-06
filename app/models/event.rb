class Event < ActiveRecord::Base
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
      body: {
        type: self.type,
        version: self.version,
        payload: self.payload
      }
    })
  end

  def async_notify
    WebHookNotifyWorker.perform_async(self.id)
  end

  def helpers
    Rails.application.routes.url_helpers
  end
end
