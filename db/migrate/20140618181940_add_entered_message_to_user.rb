class AddEnteredMessageToUser < ActiveRecord::Migration
  def change
    add_column :users, :entered_message, :string
    add_column :users, :confirmed_time, :datetime
  end
end
