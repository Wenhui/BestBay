class CreateCategories < ActiveRecord::Migration
  #create categories table
  def change
    create_table :categories do |t|

      t.timestamps
    end
  end
end
