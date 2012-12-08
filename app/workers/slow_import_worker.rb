class SlowImportWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :slow_imports
  
  def perform(slug, file)
    Feed.import(slug, file)
  end
end