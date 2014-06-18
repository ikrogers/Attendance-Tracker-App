class AddOriginalMessageToUser < ActiveRecord::Migration
  def change
    add_column :users, :original_message, :string
  end
end
