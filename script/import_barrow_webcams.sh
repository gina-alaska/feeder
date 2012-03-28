if [ -n "$1" ]
then
  bundle exec rails runner "Feed.import('webcam-uaf-barrow-seaice-images', '$1')"
else
  echo "File name is required"
fi
