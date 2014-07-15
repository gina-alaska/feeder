class IngestWorker
  include Sidekiq::Worker
  sidekiq_options :queue => 'high'
  
  def perform(file)
    Feed.ingest(file)
    Sunspot.commit
  end
end