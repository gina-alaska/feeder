if [ -z "$1" ]; then
  echo "Modis slug required"
  exit 1
fi
if [ -z "$2" ]; then
  echo "Filename is required"
  exit 1
fi

bundle exec rails runner "Feed.import('$1', '$2')" -e production
