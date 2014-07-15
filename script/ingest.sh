if [ -z "$1" ]; then
  echo "Filename is required"
  exit 1
fi

if [ -z $RAILS_ENV ]; then
  RAILS_ENV=production
fi

bundle exec rails runner "IngestWorker.perform_async('$1')" -e $RAILS_ENV
