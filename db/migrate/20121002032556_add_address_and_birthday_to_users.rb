class AddAddressAndBirthdayToUsers < ActiveRecord::Migration
  #add cloumns address and birthday to users table
  def change
    add_column :users, :address, :string
    add_column :users, :birthdate, :date
  end
end
