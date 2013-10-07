#Corresponding database table: comments
#This class describes a comment that a user can leave for an item.
# #It has the following attributes:
#   [created_at]             :datetime
#   [updated_at]             :datetime
#   [id]                     :integer    id of the comment
#   [item_id]                :integer    id of the item that is commented; must be present
#   [user_id]                :integer    id of the user who leaves a comment; must be present
#   [content]                :string     the body of the comment; must be present and is limited to 140 characters
# Comment associations with other models:
# The comment belongs to a user and to an item.

class Comment < ActiveRecord::Base
  attr_accessible :content, :item_id, :user_id

  belongs_to :commenter,   :class_name=>'User', :foreign_key => 'user_id'
  belongs_to :commented_item,  :class_name =>'Item', :foreign_key => 'item_id'

  validates :content, :presence => true, :length => {maximum:140}

  validates :user_id, :presence => true
  validates :item_id, :presence => true

  default_scope order: 'comments.created_at DESC'
end
