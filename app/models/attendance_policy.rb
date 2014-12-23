class AttendancePolicy < ActiveRecord::Base
  
  validates :message, :presence => true
  validates :absence_milestone, :presence => true
  validates_uniqueness_of :absence_milestone, scope: [:event, :groups_id], :message => "may not be repeated for the same event"
  validates :action, :presence => true
  validates :event, :presence => {:message => "must be created first"}
  
  
end
