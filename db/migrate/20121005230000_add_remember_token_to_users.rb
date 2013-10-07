class AddRememberTokenToUsers < ActiveRecord::Migration
  #add cloumn remember token to users table
  #so the website can determine the current user
  def change
    add_column :users, :remember_token, :string
    add_index  :users, :remember_token
  end
end
