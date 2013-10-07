class RemoveBidTimeFromItems < ActiveRecord::Migration
  #remove bid_time from items, as we use auction_end instead
  def up
    remove_column :items, :bid_time
  end

  #add bid_time column to items
  def down
    add_column :items, :bid_time, :time
  end
end
