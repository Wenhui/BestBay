class CreateWatches < ActiveRecord::Migration
  #create the watches table with corresponding attributes
  def change
    create_table :watches do |t|

      t.timestamps
    end
  end
end
