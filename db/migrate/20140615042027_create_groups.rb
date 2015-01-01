class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.text :name
      t.references :users, index: true
      t.references :groups, index: true 
      t.text :grouptype
      t.boolean :unique_user_group
      t.timestamps
    end
  end
end
