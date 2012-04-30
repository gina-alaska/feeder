if [ -n "$1" ]
then
  bundle exec rails runner "Feed.import('npp-gina-alaska-truecolor-images', '$1', 'npp')"
else
  echo "File name is required"
fi
