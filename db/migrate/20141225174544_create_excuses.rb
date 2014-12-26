class CreateExcuses < ActiveRecord::Migration
  def change
    create_table :excuses do |t|
      t.integer :user_id
      t.text :event
      t.text :excused_days
      t.datetime :timeframe
      t.timestamps
    end
  end
end
