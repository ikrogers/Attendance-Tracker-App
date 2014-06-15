class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :messages
      t.references :groups, index: true
      t.boolean :confirm
      t.datetime :all_confirm
      t.string :delivery_method
    end
  end
end
