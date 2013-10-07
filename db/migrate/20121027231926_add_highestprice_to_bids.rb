class AddHighestpriceToBids < ActiveRecord::Migration
  #add column highest_price to items table
  def change
  	add_column :items, :highest_price, :float, default: 0
  end
end
