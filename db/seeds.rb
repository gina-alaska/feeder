# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

radar = Feed.create({
  slug: 'barrow_radar',
  title: 'Barrow Radar',
  description: 'Barrow Radar data showing ice flow',
  author: 'Someone',
  where: 'POINT(-156.673 71.328)'
})

animations = Feed.create({
  slug: 'barrow_radar_animations',
  title: 'Barrow Radar Animation',
  description: 'Barrow Radar animation showing ice flow',
  author: 'Someone',
  where: 'POINT(-156.673 71.328)'
})