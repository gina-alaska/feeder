if [ -z "$1" ]; then
  echo "Feed slug required"
  exit 1
fi
if [ -z "$2" ]; then
  echo "Filename is required"
  exit 1
fi

bundle exec rails runner "QuickImportWorker.perform_async('$1', '$2')" -e production
