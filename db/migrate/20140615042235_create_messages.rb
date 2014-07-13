class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :messages
      t.references :groups, index: true
      t.string :confirm
      t.datetime :all_confirm
      t.string :delivery_method
      t.references :users, index: true
      t.timestamps
    end
  end
end
