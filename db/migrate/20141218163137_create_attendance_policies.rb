class CreateAttendancePolicies < ActiveRecord::Migration
  def change
    create_table :attendance_policies do |t|
      t.text :message
      t.integer :absence_milestone
      t.text :action
      t.text :event
      t.integer :groups_id
      t.timestamps
    end
  end
end
