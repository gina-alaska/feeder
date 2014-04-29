class WebHookNotifyWorker
  include Sidekiq::Worker

  def perform event_id
    event = Event.find(event_id)

    response = event.send_payload

    event.update_attribute(:response, response)
  end
end
