#Corresponding table name: Items;
#The Class describes an auctioned item with the following attributes:
#   [user_id]              :integer     must be present; this is the seller's id
#   [name]                 :string      must be present; item name
#   [description]          :string      must be present
#   [start_price]          :float       greater than 0;
#                                                 lowest bid price
#   [reserve_price]        :float       greater than 0;
#                                                 lowest price at which the item will be sold
#   [highest_price]        :float       the highest bid price when the auction is closed
#   [winner_id]            :integer     the buyer who wins the auction
#   [auction_end]          :datetime    must be present,the date and time when the auction ends
#Item image
# [picture_file_name]         :string
# [picture_content_type]      :string
# [picture_file_size]         :integer
# [picture_updated_at]        :datetime
#These fields are created by default
#   [created_at]          :datetime
#   [updated_at]          :datetime
#   [id]                  :integer
#Item associations with other models
# [users]       item belongs to a user;
#               item is destroyed when the user object is destroyed
# [watches]     item can have many watches
#               (stored in the Watches table)
# [watchers]    item can have many watchers whose ids can be retrieved through the watches table
# [bids]        item can have many bids  (stored in the Bids table)
# [bidders]     item can have many bidders through the bids
# [categories]  item can have and belong to many categories
class Item < ActiveRecord::Base
  attr_accessible :auction_end, :description, :name, :reserve_price, :start_price, :picture, :category_ids, :highest_price, :winner_id, :notificated
  #bid_time is not stored in the database; it is used to calculate the auction_end time before saving the item object
  attr_accessor :bid_time

  has_attached_file :picture, :styles => { :thumb => "100x100>", :medium => "150x150>", :large => "300x300" },
                    :url => "/system/:attachment/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/system/:attachment/:id/:style/:basename.:extension"

  validates :user_id, presence: true
  validates :name, presence: true
  validates :description, presence: true

  validates_numericality_of :start_price, :greater_than => 0
  validates_numericality_of :reserve_price, :greater_than => 0

  

  belongs_to :user
  has_many :watches
  has_many :watchers, :through => :watches
  has_many :bids, dependent: :destroy
  has_many :bidders, :through => :bids
  has_many :comments, dependent: :destroy
  has_many :commenter, :through => :comments

  has_and_belongs_to_many :categories
  default_scope order: 'items.created_at DESC'

  #The method checks whether the auction has ended
  def expired?
    if(DateTime.now > auction_end.localtime)  
      return true
    else 
      return false
    end
  end


  #The method checks whether the aucion has been notified to user
  def notified?
    if(expired? == true && notificated == false) 
      return false
    else
      return true
    end
  end

  #search for items according to a certain key word
  def self.search(search)
    search_condition = "%" + search + "%"
    Item.find(:all, :conditions => ['name LIKE ? OR description LIKE ?',
     search_condition, search_condition])
  end

end
