class AddAuctionEndToItems < ActiveRecord::Migration
  #add column auction_end and set it current time in default
  def change
    add_column :items, :auction_end, :datetime
    Item.all.each do |item|
      item.update_attributes!(:auction_end => DateTime.now)
    end
  end
end
