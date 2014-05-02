class CreateEventWorker
  include Sidekiq::Worker

  def perform(entry_id, type)
    entry = Entry.find(entry_id)

    webhooks = WebHook.where(feed_id: entry.feed, active:true).pluck(:id)

    webhooks.each do |webhook|
      event = CreateEvent.create(type: type, entry_id: entry_id, web_hook_id: webhook)
      WebHookNotifyWorker.perform_async(event.id)
    end
  end
end
