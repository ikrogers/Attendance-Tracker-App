class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.text :name
      t.text :ptdays
      t.text :llabdays
      t.references :users, index: true
      t.references :groups, index: true 
      t.text :grouptype
      t.timestamps
    end
  end
end
