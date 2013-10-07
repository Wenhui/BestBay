class AddAdminToUsers < ActiveRecord::Migration
  #add  cloumn admin attribute to users table to destinguish admin and ordinary users
  def change
    add_column :users, :admin, :boolean, default: false
  end
end
