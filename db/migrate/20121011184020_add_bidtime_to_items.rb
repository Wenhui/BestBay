class AddBidtimeToItems < ActiveRecord::Migration
  #add cloumn bid_time to items
  def change
    add_column :items, :bid_time, :integer
  end
end
