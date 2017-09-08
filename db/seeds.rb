# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


users = [
  {
    name: "Brian"
  },
  {
    name: "Rob"
  },
  {
    name: "Brad"
  },
  {
    name: "Charlie"
  },
  {
    name: "Saugat"
  },
  {
    name: "Laura"
  }
]
users.each {|x| User.create(x)}

teams = [
  {
    name: "Jets",
    wins: rand(4),
    losses: rand(12),
    ties: 0,
    points_for: rand(99),
    points_against: rand(99),
    long_record: {},
    user_id: User.all.shuffle.first.id
  },
  {
    name: "Pats",
    wins: rand(12),
    losses: rand(4),
    ties: 0,
    points_for: rand(199),
    points_against: rand(99),
    long_record: {},
    user_id: User.all.shuffle.first.id
  },
  {
    name: "Bills",
    wins: rand(8),
    losses: rand(8),
    ties: 0,
    points_for: rand(99),
    points_against: rand(99),
    long_record: {},
    user_id: User.all.shuffle.first.id
  },
  {
    name: "Dolphins",
    wins: rand(10),
    losses: rand(6),
    ties: 0,
    points_for: rand(130),
    points_against: rand(99),
    long_record: {},
    user_id: User.all.shuffle.first.id
  },
]

teams.each {|x| Team.create(x)}
