# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create(:email => "admin@admin.com", :password => "123123123", :password_confirmation => "123123123", :admin => true)
User.create(:email => "ikrogers91@gmail.com", :password => "123123123", :password_confirmation => "123123123", :admin => false, :phone => "9125802665", :carrier=>"Verizon")
User.create(:email => "ikrogers@valdosta.edu", :password => "123123123", :password_confirmation => "123123123", :admin => false, :phone => "9125802665", :carrier=>"Verizon", :tracker => true)


