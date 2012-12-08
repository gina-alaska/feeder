class QuickImportWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :quick_imports
  
  def perform(slug, file)
    Feed.import(slug, file)
  end
end