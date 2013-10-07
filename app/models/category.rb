#Corresponding table: categories
#This class describes a general category, such as "cars", "entertainment",etc.
#The category must have a unique name. It has and belongs to many items. The item must be valid before it can be added to the category
class Category < ActiveRecord::Base
  attr_accessible :name
  has_and_belongs_to_many :items,  :before_add => [:check_unique]

  validates :name, presence: true, uniqueness: true

  #The method checks if the item is valid. It is accessed before adding a new item to the category
  def check_unique(item)
    item.valid?
  end


end
