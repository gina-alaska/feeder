class ImportWorker
  include Sidekiq::Worker

  def perform(slug, file)
    feed = Feed.import(slug, file)
    Sunspot.commit
  end

  def perform(id)
    import = Import.find(id)

    feed = Feed.find_by(slug: import.feed)
    feed.entries.new(image_url: import.url, event_at: import.timestamp)
  end
end