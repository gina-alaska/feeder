# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

webcam_s = Sensor.create(name: 'Webcam')
radar_s = Sensor.create(name: 'Radar')
viirs_s = Sensor.create(name: 'VIIRS')
modis_s = Sensor.create(name: 'MODIS')


radar = Feed.create({
  slug: 'radar-uaf-barrow-seaice-images',
  title: 'Barrow Radar',
  description: 'Barrow Radar data showing ice flow',
  author: 'Someone',
  sensor: radar_s,
  where: 'POINT(-156.673 71.328)'
})

webcam = Feed.create({
  slug: 'webcam-uaf-barrow-seaice-images',
  title: 'Barrow Webcam',
  description: 'Barrow Webcam',
  author: 'Someone',
  sensor: webcam_s,
  where: 'POINT(-156.673 71.328)'
})

npp = Feed.create({
  slug: 'npp-gina-alaska-truecolor-images',
  title: 'NPP Truecolor Images',
  description: 'NPP Truecolor Images',
  author: 'GINA',
  sensor: viirs_s,
  where: 'POINT(-147.723056 64.843611)'  
})

dnb = Feed.create({
  slug: 'npp-gina-alaska-dnb-images',
  title: 'NPP DNB Images',
  description: 'NPP DNB Images',
  author: 'GINA',
  sensor: viirs_s,
  where: 'POINT(-147.723056 64.843611)'  
})

Feed.create({
  slug: 'modis-gina-alaska-naturalcolor-images',
  title: 'MODIS Naturalcolor',
  description: 'MODIS Naturalcolor',
  author: 'GINA',
  sensor: modis_s,
  where: 'POINT(-147.723056 64.843611)'  
})

Feed.create({
  slug: 'modis-gina-alaska-721_landcover-images',
  title: 'MODIS 721 Landcover',
  description: 'MODIS 721 Landcover',
  author: 'GINA',
  sensor: modis_s,
  where: 'POINT(-147.723056 64.843611)'  
})

Feed.create({
  slug: 'modis-gina-alaska-261_landcover-images',
  title: 'MODIS 261 Landcover',
  description: 'MODIS 261 Landcover',
  author: 'GINA',
  sensor: modis_s,
  where: 'POINT(-147.723056 64.843611)'  
})

Feed.create({
  slug: 'modis-gina-alaska-367_snowcover-images',
  title: 'MODIS 367 Snowcover',
  description: 'MODIS 367 Snowcover',
  author: 'GINA',
  sensor: modis_s,
  where: 'POINT(-147.723056 64.843611)'  
})

Feed.create({
  slug: 'modis-gina-alaska-thermal-images',
  title: 'MODIS Thermal',
  description: 'MODIS Thermal',
  author: 'GINA',
  sensor: modis_s,
  where: 'POINT(-147.723056 64.843611)'  
})


