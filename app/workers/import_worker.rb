class ImportWorker
  include Sidekiq::Worker

  def perform(id)
    import = Import.find(id)

    feed = Feed.find_by(slug: import.feed)
    entry = feed.import(image_url: import.url, event_at: import.timestamp)
    entry.save!
    import.destroy
  end
end