class CreateAttendances < ActiveRecord::Migration
  def change
    create_table :attendances do |t|
      t.boolean :absent
      t.boolean :tardy
      t.boolean :absence_tardy
      t.references :user, index: true
      t.text :event
      t.integer :tracker_id
      t.integer :groups_id
      t.text :date_recorded
      t.timestamps
    end
  end
end
