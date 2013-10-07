class Addindextobids < ActiveRecord::Migration
  #add index user_id and item_id to bids
  def change
  	add_index :bids, :user_id
  	add_index :bids, :item_id
  end
end
