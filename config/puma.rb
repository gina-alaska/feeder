workers Integer(ENV['WEB_CONCURRENCY'] || 1)
threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads 1, threads_count

ENV['PUMA_PRELOAD_APP']
prune_bundler

rackup      DefaultRackup
port        Integer( ENV['PUMA_PORT'] || 9292 )
environment ENV['RAILS_ENV'] || 'development'
pidfile     ENV['PUMA_PIDFILE'] || './tmp/pids/puma.pid'
worker_timeout 240

# not needed unless we are using preload_app!
# if ENV['PUMA_PRELOAD_APP'] == 'preload_app!'
#   on_worker_boot do
#     # Worker specific setup for Rails 4.1+
#     # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
#     ActiveRecord::Base.establish_connection
#   end
# end
