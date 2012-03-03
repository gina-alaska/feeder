# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

barrow = Feed.create({
  slug: 'barrow_radar',
  title: 'Barrow Radar',
  description: 'Barrow Radar data showing ice flow',
  author: 'Someone',
  where: 'POINT(-156.673 71.328)'
})