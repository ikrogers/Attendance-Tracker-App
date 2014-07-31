class CreateExcusedUsers < ActiveRecord::Migration
  def change
    create_table :excused_users do |t|
      t.references :users, index: true
      t.references :groups, index: true
      t.boolean :excused_pt
      t.text :excused_pt_day
      t.boolean :excused_llab
      t.text :excused_llab_day
      t.timestamps
    end
  end
end
