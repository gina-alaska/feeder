class SlowImportWorker < ImportWorker
  sidekiq_options :queue => 'low'
end