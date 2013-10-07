class CreateComments < ActiveRecord::Migration
  #create comments table with corresponding attributes / drop comments table
  def change
    create_table :comments do |t|
      t.string :content
      t.integer :user_id
      t.integer :item_id

      t.timestamps
    end
    add_index :comments, [:user_id]
  end
end
