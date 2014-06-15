class CreateGroup < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.references :users, index: true
      
      t.references :groups, index: true 
      
      
    end
  end
end
