class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :messages
      t.text :subject
      t.references :groups, index: true
      t.text :confirm
      t.boolean :all_confirm
      t.datetime :all_confirm_time
      t.text :delivery_method
      t.text :notify
      t.text :notification_method
      t.references :users, index: true
      t.timestamps
    end
  end
end
