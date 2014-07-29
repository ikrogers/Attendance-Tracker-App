# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create(:email => "admin@admin.com",:fname=>"Billybob", :lname=>"Thorton-Jr.", :phone => "0000000000", :carrier=>"Verizon", :password => "123123123", :password_confirmation => "123123123", :admin => true, :uberadmin => true )
User.create(:email => "ikrogers91@gmail.com",:fname=>"Billybob", :lname=>"Thorton-JrJr.", :password => "123123123", :password_confirmation => "123123123", :admin => false, :phone => "9125802665", :carrier=>"Verizon")
User.create(:email => "ikrogers@valdosta.edu", :password => "123123123", :password_confirmation => "123123123", :admin => false, :phone => "9125802665", :carrier=>"Verizon", :tracker => true)
User.create(:email => "ikrogers1@valdosta.edu", :password => "123123123", :password_confirmation => "123123123", :admin => false, :phone => "9125802665", :carrier=>"Verizon", :tracker => true)
User.create(:email => "ikrogers2@valdosta.edu", :password => "123123123", :password_confirmation => "123123123", :admin => false, :phone => "9125802665", :carrier=>"Verizon", :tracker => false)
User.create(:email => "ikrogers3@valdosta.edu", :password => "123123123", :password_confirmation => "123123123", :admin => false, :phone => "9125802665", :carrier=>"Verizon", :tracker => false)
User.create(:email => "ikrogers4@valdosta.edu", :password => "123123123", :password_confirmation => "123123123", :admin => false, :phone => "9125802665", :carrier=>"Verizon", :tracker => false)
User.create(:email => "ikrogers5@valdosta.edu", :password => "123123123", :password_confirmation => "123123123", :admin => false, :phone => "9125802665", :carrier=>"Verizon", :tracker => false)
User.create(:email => "ikrogers6@valdosta.edu", :password => "123123123", :password_confirmation => "123123123", :admin => false, :phone => "9125802665", :carrier=>"Verizon", :tracker => false)
User.create(:email => "ikrogers7@valdosta.edu", :password => "123123123", :password_confirmation => "123123123", :admin => false, :phone => "9125802665", :carrier=>"Verizon", :tracker => false)
User.create(:email => "ikrogers8@valdosta.edu", :password => "123123123", :password_confirmation => "123123123", :admin => false, :phone => "9125802665", :carrier=>"Verizon", :tracker => false)
User.create(:email => "ikrogers9@valdosta.edu", :password => "123123123", :password_confirmation => "123123123", :admin => false, :phone => "9125802665", :carrier=>"Verizon", :tracker => false)


