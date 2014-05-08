class WebHookNotifyWorker
  include Sidekiq::Worker

  def perform event_id
    event = Event.find(event_id)

    response = event.notify

    status = response.response.kind_of?(Net::HTTPSuccess) ? "success" : "failure"
    event.update_attribute(:response, "success")
  end
end
