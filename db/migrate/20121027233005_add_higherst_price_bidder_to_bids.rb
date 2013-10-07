class AddHigherstPriceBidderToBids < ActiveRecord::Migration
  #add column winner_id to items table, so the item can track who won the bid
  def change
  	add_column :items, :winner_id, :integer
  end
end
