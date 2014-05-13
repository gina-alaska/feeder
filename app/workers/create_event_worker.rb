class CreateEventWorker
  include Sidekiq::Worker

  def perform(entry_id)
    entry = Entry.find(entry_id)

    webhooks = WebHook.where(feed_id: entry.feed.id, active:true).pluck(:id)

    webhooks.each do |webhook|
      event = CreateEvent.create(entry_id: entry_id, web_hook_id: webhook)
      WebHookNotifyWorker.perform_async(event.id)
    end
  end
end
