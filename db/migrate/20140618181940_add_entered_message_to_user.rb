class AddEnteredMessageToUser < ActiveRecord::Migration
  def change
    add_column :users, :entered_message, :string
  end
end
