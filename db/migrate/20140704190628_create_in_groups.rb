class CreateInGroups < ActiveRecord::Migration
  def change
    create_table :in_groups do |t|
      t.references :users, index: :true
      t.references :groups, index: :true
      t.timestamps
    end
  end
end
