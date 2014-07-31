class CreateExcusedUsers < ActiveRecord::Migration
  def change
    create_table :excused_users do |t|
      t.references :users, index: true
      t.references :groups, index: true
      t.boolean :excused_pt
      t.boolean :excused_llab
      t.timestamps
    end
  end
end
