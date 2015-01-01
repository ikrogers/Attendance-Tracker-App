class Group < ActiveRecord::Base
  has_many :in_group
  
  validates :name, :presence => true
end
