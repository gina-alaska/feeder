class ImportWorker
  include Sidekiq::Worker
  
  def perform(slug, file)
    Feed.import(slug, file)
  end
end