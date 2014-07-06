class CreateAttendances < ActiveRecord::Migration
  def change
    create_table :attendances do |t|
      t.boolean :absent
      t.references :user, index: true
      
      t.timestamps
    end
  end
end
