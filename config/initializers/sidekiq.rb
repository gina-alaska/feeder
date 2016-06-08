redis_host = ENV['REDIS_HOST'] || 'localhost'
redis_port = ENV['REDIS_PORT'] || '6379'
Sidekiq.configure_server do |config|
  config.redis = { :url => "redis://#{redis_host}:#{redis_port}/12", :namespace => "feeder_#{Rails.env}" }
end

# When in Unicorn, this block needs to go in unicorn's `after_fork` callback:
Sidekiq.configure_client do |config|
  config.redis = { :url => "redis://#{redis_host}:#{redis_port}/12", :namespace => "feeder_#{Rails.env}" }
end
