class AddCreditCardToUsers < ActiveRecord::Migration
  #add cloumns credit card information to users table
  def change
    add_column :users, :card_number, :string
    add_column :users, :expiration_date, :date
    add_column :users, :security_num, :string
  end
end
