if [ -z $RAILS_ENV ]; then
  RAILS_ENV=production
fi

mkdir -p tmp/pids
bundle exec sidekiq -C config/sidekiq.yml -e $RAILS_ENV
