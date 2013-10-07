class CreateItems < ActiveRecord::Migration
  #create the items table with corresponding attributes
  #add index user_id and created_at for looking up items
  def change
    create_table :items do |t|
      t.integer :user_id
      t.string :name
      t.string :description
      t.float :start_price
      t.float :reserve_price
      t.time :bid_time

      t.timestamps
    end
    add_index :items, [:user_id, :created_at]
  end
end
