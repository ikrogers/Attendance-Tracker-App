class AddGroupsToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :groups, index: true   
  end
end
