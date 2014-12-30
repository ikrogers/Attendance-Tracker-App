class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.text :event_name
      t.text :event_days
      t.integer :max_tardies
      t.integer :absence_max
      t.timestamps
    end
  end
end
