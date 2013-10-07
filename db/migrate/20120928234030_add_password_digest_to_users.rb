class AddPasswordDigestToUsers < ActiveRecord::Migration
  #add cloumn password digest to users
  def change
    add_column :users, :password_digest, :string
  end
end
