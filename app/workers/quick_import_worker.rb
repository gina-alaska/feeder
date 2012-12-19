class QuickImportWorker < ImportWorker
  sidekiq_options :queue => 'high'
end