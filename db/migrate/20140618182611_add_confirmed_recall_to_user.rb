class AddConfirmedRecallToUser < ActiveRecord::Migration
  def change
    add_column :users, :confirmed_recall, :boolean
  end
end
