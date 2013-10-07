class AddinBidNotifiedToBids < ActiveRecord::Migration
  #add column inBid_notify to bids table
  def change
  	add_column :bids, :inBid_notify, :boolean, default: false
  end
end
