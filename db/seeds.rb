
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(:email => "ikrogers@valdosta.edu",:fname=>"Ilya", :lname=>"Rogers", :phone => "9125802665", :carrier=>"Verizon", :password => "123123123", :confirmed_at => '2015-01-10 17:14:57.899414', :password_confirmation => "123123123", :admin => true, :uberadmin => true)
User.create(:email => "ikrogers2@valdosta.edu",:fname=>"Ilya", :lname=>"Rogers", :phone => "9125802665", :carrier=>"Verizon", :password => "123123123", :confirmed_at => '2015-01-10 17:14:57.899414', :password_confirmation => "123123123", :admin => true, :uberadmin => true)
User.create(:email => "ikrogers3@valdosta.edu",:fname=>"Ilya", :lname=>"Rogers", :phone => "9125802665", :carrier=>"Verizon", :password => "123123123", :confirmed_at => '2015-01-10 17:14:57.899414', :password_confirmation => "123123123", :admin => true, :uberadmin => true)
