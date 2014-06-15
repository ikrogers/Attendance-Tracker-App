class CreateMessageList < ActiveRecord::Migration
  def change
    create_table :message_lists do |t|
      t.references :messages, index: true
      t.references :users, index: true
      t.boolean :confirmed
      t.datetime :confirm_date
    end
  end
end
