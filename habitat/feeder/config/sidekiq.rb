Sidekiq.configure_server do |config|
  config.redis = { :url => "redis://{{cfg.redis.host}}:{{cfg.redis.port}}/12", :namespace => "feeder_{{rails_env}}" }
end

# When in Unicorn, this block needs to go in unicorn's `after_fork` callback:
Sidekiq.configure_client do |config|
  config.redis = { :url => "redis://{{cfg.redis.host}}:{{cfg.redis.port}}/12", :namespace => "feeder_{{rails_env}}" }
end
