#Corresponding database table: watches
#This class creates a many to many association between the item and the user model.
#When a user adds an item to his watchlist, a watch object of Class Watch is created.
#It has the following attributes:
#   [created_at]             :datetime
#   [updated_at]             :datetime
#   [id]                     :integer    id of the watch entry
#   [item_id]                :integer    id of the item to be watched; must be present
#   [user_id]                :integer    id of the user who watches the item; must be present
#Watch associations with other models
# [users]     a watch belongs to a watcher who is of class User;
#             linked to the users table through foreign_key =user_id
# [items]     a watch belongs to a watched_item which is of class Item;
#             linked to the items table through foreign_key =item_id
class Watch < ActiveRecord::Base
  attr_accessible :user_id, :item_id
  belongs_to :watcher,   :class_name=>'User', :foreign_key => 'user_id'
  belongs_to :watched_item,  :class_name =>'Item', :foreign_key => 'item_id'

  validates :user_id, :presence => true
  validates :item_id, :presence => true
end
