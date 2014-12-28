class Attendance < ActiveRecord::Base
  has_many :users
  
end
