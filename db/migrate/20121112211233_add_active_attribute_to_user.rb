class AddActiveAttributeToUser < ActiveRecord::Migration
  #add column active to users table
  def change
    add_column :users, :active, :boolean, default: true
  end
end
