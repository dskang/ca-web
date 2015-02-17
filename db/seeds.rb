# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

schools = %w(princeton harvard yale brown upenn columbia dartmouth cornell)
schools.each { |school| School.create(name: school) }

test_user = User.new(email: 'admin@princeton.edu', password: 'originblack')
test_user.skip_confirmation!
test_user.save
