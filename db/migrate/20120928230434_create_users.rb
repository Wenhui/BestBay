class CreateUsers < ActiveRecord::Migration
  #create the users table with corresponding attributes
  def change
    create_table :users do |t|
      t.string :userName
      t.string :email
      t.string :password

      t.timestamps
    end
  end
end
