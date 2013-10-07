class AddNameToCategorie < ActiveRecord::Migration
  #add cloumn name to categories table
  def change
    add_column :categories, :name, :string
  end
end
