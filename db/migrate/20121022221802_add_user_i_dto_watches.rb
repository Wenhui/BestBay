class AddUserIDtoWatches < ActiveRecord::Migration
  #add coloum user_id to watches, a watch will have a corresponding user
  def change
    add_column :watches, :user_id, :integer
  end
end
