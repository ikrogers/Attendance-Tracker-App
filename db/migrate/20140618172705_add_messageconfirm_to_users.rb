class AddMessageconfirmToUsers < ActiveRecord::Migration
  def change
    add_column :users, :messageconfirm_token, :string
    add_column :users, :confirmtoken_sent_at, :datetime
  end
end
