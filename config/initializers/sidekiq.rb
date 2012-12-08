# rails_root = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/../..'
# rails_env = ENV['RAILS_ENV'] || 'development'
# 
# resque_config = YAML.load_file(rails_root + '/config/resque.yml')
# Resque.redis = resque_config[rails_env]
# Resque.redis.namespace = "resque:gina_puffin_feeder"

Sidekiq.configure_server do |config|
  config.redis = { :url => 'redis://feeder-vm.gina.alaska.edu:6379/12', :namespace => "feeder_#{Rails.env}" }
end

# When in Unicorn, this block needs to go in unicorn's `after_fork` callback:
Sidekiq.configure_client do |config|
  config.redis = { :url => 'redis://feeder-vm.gina.alaska.edu:6379/12', :namespace => "feeder_#{Rails.env}" }
end