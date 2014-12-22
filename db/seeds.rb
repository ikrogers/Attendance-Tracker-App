
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create(:email => "ikrogers@valdosta.edu",:fname=>"Ilya", :lname=>"Rogers", :phone => "9125802665", :carrier=>"Verizon", :password => "123123123", :password_confirmation => "123123123", :admin => true, :uberadmin => true)
User.create(:email => "ikrogers91@gmail.com",:fname=>"Ayli", :lname=>"Sregor", :password => "123123123", :password_confirmation => "123123123", :phone => "9125802665", :carrier=>"Verizon", :admin => true, :uberadmin => true)
User.create(:email => "ikrogers92@gmail.com",:fname=>"Billy", :lname=>"Sregor", :password => "123123123", :password_confirmation => "123123123", :phone => "9125802665", :carrier=>"Verizon", :admin => true, :uberadmin => true)
Event.create(:name => "Physical Training", :absence_max => 10)
Event.create(:name => "Leadership Lab", :absence_max => 20)
Event.create(:name => "CS4500", :absence_max => 15)

