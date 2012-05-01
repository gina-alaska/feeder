# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

radar = Feed.create({
  slug: 'radar-uaf-barrow-seaice-images',
  title: 'Barrow Radar',
  description: 'Barrow Radar data showing ice flow',
  author: 'Someone',
  where: 'POINT(-156.673 71.328)'
})

animations = Feed.create({
  slug: 'radar-uaf-barrow-seaice-animations',
  title: 'Barrow Radar Animation',
  description: 'Barrow Radar animation showing ice flow',
  author: 'Someone',
  where: 'POINT(-156.673 71.328)'
})

webcam = Feed.create({
  slug: 'webcam-uaf-barrow-seaice-images',
  title: 'Barrow Webcam',
  description: 'Barrow Webcam',
  author: 'Someone',
  where: 'POINT(-156.673 71.328)'
})

webcam = Feed.create({
  slug: 'webcam-uaf-barrow-seaice-animations',
  title: 'Barrow Webcam Animations',
  description: 'Barrow Webcam',
  author: 'Someone',
  where: 'POINT(-156.673 71.328)'
})

npp = Feed.create({
  slug: 'npp-gina-alaska-truecolor-images',
  title: 'NPP Truecolor Images',
  description: 'NPP Truecolor Images',
  author: 'GINA',
  where: 'POINT(-147.723056 64.843611)'  
})
