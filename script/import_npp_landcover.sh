if [ -n "$1" ]
then
  bundle exec rails runner "Feed.import('npp-gina-alaska-landcover-images', '$1')" -e production
else
  echo "File name is required"
fi
