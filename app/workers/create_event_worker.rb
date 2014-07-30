class CreateEventWorker
  include Sidekiq::Worker

  def perform(entry_id)
    entry = Entry.find(entry_id)

    entry.feed.web_hooks.active.each do |webhook|
      event = CreateEvent.create(entry_id: entry_id, web_hook_id: webhook)
      WebHookNotifyWorker.perform_async(event.id)
    end
  end
end
