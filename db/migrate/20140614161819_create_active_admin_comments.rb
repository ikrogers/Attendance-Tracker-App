class CreateActiveAdminComments < ActiveRecord::Migration
  def self.up
    create_table :active_admin_comments do |t|
      t.text :namespace
      t.text   :body
      t.text :resource_id,   null: false
      t.text :resource_type, null: false
      t.references :author, polymorphic: true
      t.timestamps
    end
    add_index :active_admin_comments, [:namespace]
    add_index :active_admin_comments, [:author_type, :author_id]
    add_index :active_admin_comments, [:resource_type, :resource_id]
  end

  def self.down
    drop_table :active_admin_comments
  end
end
