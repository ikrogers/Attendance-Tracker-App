class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :messages
      t.references :groups, index: true
      t.string :confirm
      t.boolean :all_confirm
      t.datetime :all_confirm_time
      t.string :delivery_method
      t.string :notify
      t.string :notification_method
      t.references :users, index: true
      t.timestamps
    end
  end
end
