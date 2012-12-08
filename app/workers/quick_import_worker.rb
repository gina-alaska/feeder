class QuickImportWorker
  include Sidekiq::Worker
  sidekiq_options :queue => 'high'
  
  def perform(slug, file)
    Feed.import(slug, file)
  end
end