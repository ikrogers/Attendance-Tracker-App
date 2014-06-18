class Message < ActiveRecord::Base
  
  has_many :users
  
  CARRIER_TYPES = ["AT&T","Verizon", "Boost Mobile", "Cellular One", "Metro PCS", "Nextel", "Sprint", "T-Mobile", "Tracfone"]

  
end
