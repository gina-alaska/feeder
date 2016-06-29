class ImportWorker
  include Sidekiq::Worker

  def perform(id)
    import = Import.find(id)

    feed = Feed.find_by(slug: import.feed)
    entry = feed.import(import.url, import.timestamp.to_s)
    import.destroy
  end
end
