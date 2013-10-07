class AddIndexToUsersEmail < ActiveRecord::Migration
  #add index email for looking up users
  def change
    add_index :users, :email, unique: true
  end
end
