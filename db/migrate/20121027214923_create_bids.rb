class CreateBids < ActiveRecord::Migration
  #create the bids table with corresponding attributes
  def change
    create_table :bids do |t|
      t.integer :user_id
      t.integer :item_id
      t.float :price, default: 0

      t.timestamps
    end
  end
end
