class AddNotificatedToItems < ActiveRecord::Migration
   #add column notificated to items table
  def change
  	add_column :items, :notificated, :boolean, default: false
  end
end
