class RemoveAuctionEndFromItems < ActiveRecord::Migration
  #remove auction_end column to items
  def up
    remove_column :items, :auction_end

  end

  #add auction_end cloumn to items
  def down

    add_column :items, :auction_end, :integer
  end
end
