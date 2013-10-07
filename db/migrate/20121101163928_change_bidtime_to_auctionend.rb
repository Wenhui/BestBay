class ChangeBidtimeToAuctionend < ActiveRecord::Migration
  #rename bid_time to auction_end
  def up
    rename_column :items,:bid_time, :auction_end

  end

  #rename auction_end to bid_time
  def down
    rename_column :items,:auction_end, :bid_time
  end
end
