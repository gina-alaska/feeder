class CreateEventWorker
  include Sidekiq::Worker

  def perform(entry_id)
    entry = Entry.find(entry_id)
    entry.notify_webhooks
  end
end
