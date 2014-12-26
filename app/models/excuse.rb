class Excuse < ActiveRecord::Base
  include ActiveModel::Validations
  
  serialize :excused_days
  validates_uniqueness_of :user_id, scope: [:event], :message => "may not be repeated for the same event"
  validates :excused_days, :excusedDays => true
  validates :event, :presence => true
  
  
end
