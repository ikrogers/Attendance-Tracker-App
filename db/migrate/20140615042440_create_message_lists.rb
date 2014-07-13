class CreateMessageLists < ActiveRecord::Migration
  def change
    create_table :message_lists do |t|
      t.references :messages, index: true
      t.references :users, index: true
      t.boolean :confirmed
      t.datetime :confirm_date
      t.string :messageconfirmtoken
      t.datetime :confirmtoken_sent_at
      t.string :original_message
      t.string :entered_message
      t.datetime :confirmed_time
      t.boolean :confirmed_recall
      t.timestamps
    end
  end
end
