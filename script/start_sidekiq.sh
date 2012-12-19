mkdir -p tmp/pids
bundle exec sidekiq -C config/sidekiq.yml -e production