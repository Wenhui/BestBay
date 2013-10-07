#Corresponding database table: bids
#This class creates a many to many association between the item and the user model.
#When a user places a bid on an item for the first time, a bid object of Class Bid is created.
#It has the following attributes:
#   [created_at]       :datetime
#   [updated_at]       :datetime
#   [id]               :integer    id of the bid entry
#   [item_id]          :integer    id of the item on which the bid is placed; must be present
#   [user_id]          :integer    id of the user who placed the bid; must be present
#   [price]            :float      bid price, must be present and a positive number
#   [notifiy]          :boolean    a flag of whether a closed auction has been notified to the bidder, true means it has been notified
#   [inBid_notify]     :boolean    a flag of when a bidder's bidding price is exceeded by others, whether the bidder has been notified. 
#                                  Everytime a new bid is made on this item, it will be set to false
#Bid associations with other models
# [users]     a bid belongs to a bidder who is of class User;
#             linked to the users table through foreign_key =user_id
# [items]     a bid belongs to a bid_item who is of class Item;
#             linked to the items table through foreign_key =item_id
class Bid < ActiveRecord::Base
  attr_accessible :item_id, :price, :user_id, :notifiy, :inBid_notify

  belongs_to :bidder,   :class_name=>'User', :foreign_key => 'user_id'
  belongs_to :bid_item,  :class_name =>'Item', :foreign_key => 'item_id'

  validates_numericality_of :price, :greater_than => 0
  validates :price, :presence => true

  validates :user_id, :presence => true
  validates :item_id, :presence => true
  default_scope order: 'bids.updated_at DESC'


  #This method checks whether the bid has been notified to user
  def notified? 
  	item = Item.find(item_id)
  	if(item.expired? == true && notifiy == false)
  		return false
  	else
  		return true
  	end
  end

  #This method checks whether the bid is closed or in process
  def inbid?
    item = Item.find(item_id)
    if(item.expired? == false && inBid_notify == false)
      return true
    else
      return false
    end
  end

  
end
