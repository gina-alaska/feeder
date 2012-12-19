if [ -z "$1" ]; then
  echo "Feed slug required"
  exit 1
fi
if [ -z "$2" ]; then
  echo "Filename is required"
  exit 1
fi

rails_env=${3:-production}

bundle exec rails runner "SlowImportWorker.perform_async('$1', '$2')" -e $rails_env
