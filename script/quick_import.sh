if [ -z "$1" ]; then
  echo "Feed slug required"
  exit 1
fi
if [ -z "$2" ]; then
  echo "Filename is required"
  exit 1
fi

if [ -z $RAILS_ENV ]; then
  RAILS_ENV=production
fi

RAILS_ENV=$RAILS_ENV spring rails runner "QuickImportWorker.perform_async('$1', '$2')" -e $RAILS_ENV