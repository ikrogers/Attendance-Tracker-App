class Group < ActiveRecord::Base
  has_many :in_group
  serialize :alt_event_days
  validates :name, :presence => true
end
