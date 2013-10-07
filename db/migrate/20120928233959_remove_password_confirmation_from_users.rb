class RemovePasswordConfirmationFromUsers < ActiveRecord::Migration
  #because we use another approach, so we remove the password confirmation from users
  def up
    remove_column :users, :password
  end

  def down
    add_column :users, :password, :string
  end
end
