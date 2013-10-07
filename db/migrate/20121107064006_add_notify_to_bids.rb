class AddNotifyToBids < ActiveRecord::Migration
  #add column notifie to bids table
  def change
  	add_column :bids, :notifiy, :boolean, default: false
  end
end
