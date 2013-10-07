class AddItemIdToWatches < ActiveRecord::Migration
  #add coloum item_id to watches, a watch will have a corresponding item
  def change
    add_column :watches, :item_id, :integer
  end
end
