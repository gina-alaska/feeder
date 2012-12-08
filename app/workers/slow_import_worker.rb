class SlowImportWorker
  include Sidekiq::Worker
  sidekiq_options :queue => 'low'
  
  def perform(slug, file)
    Feed.import(slug, file)
  end
end