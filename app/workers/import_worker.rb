class ImportWorker
  include Sidekiq::Worker
  
  def perform(slug, file)
    feed = Feed.import(slug, file)
    Sunspot.commit
  end
end