#Corresponding table name: Users
#The Class describes a registered user who has the following attributes:
#   [userName]    :string     must be present, unique, max length 50 characters
#   [email]       :string     must be present, unique, fit the email REGEX format
#These fields are created by default
#   [created_at]                 :datetime
#   [updated_at]                 :datetime
#   [id]                         :integer
#Password information; in database it is stored as "Password_digest"
#   [password]                :string       must be present, min length 6 characters
#   [password_confirmation]   :string       must be present, match exactly the password
#   [address]                 :string       must be present
#   [birthdate]               :date         must be present
#
#Credit card information
#   [card_number]           :string       must be present, integer with 16 digits
#   [expiration_date]       :date         must be present
#   [security_num]          :string       must be present, integer between 99 and 1000
#
#Session information is stored in the cookie, not an attribute accessible in the model
#   [remember_token]   :string
#
#Admin is false by default; can be set to true for a User on the rails console
#   [admin]           :boolean
#User associations with other models
# [items]           User can have many posted items
#                   that are destroyed when the user object is destroyed
# [watches]         User can have many watches
#                   (stored in the Watches table)
# [watched_items]   User can have many watched items
#                   whose ids can be retrieved through the watches table
# [bids]            User can have many bids
#                   (stored in the Bids table)
# [bid_items]       User can have many bid items
#                   whose ids can be retrieved through the bids table

class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation, :userName, :address, :birthdate,
  :card_number, :expiration_date, :security_num
  has_many :items, dependent: :destroy
  has_many :watches
  has_many :watched_items, :through => :watches
  has_many :bids, dependent: :destroy
  has_many :bid_items, :through => :bids
  has_many :comments, dependent: :destroy
  has_many :commented_items, :through => :comments

  has_secure_password

  before_save { |user| user.email = email.downcase }
  before_save {create_remember_token}

  validates :userName,  presence: true, length: { maximum: 50 }, uniqueness: true
  #Defines the email format
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  validates :address, presence: true
  validates :birthdate, presence: true

  validates_numericality_of :card_number, :only_integer => true,
  :greater_than => 999999999999999, :less_than => 10000000000000000, :message => "should be 16 digits"
  validates_numericality_of :security_num, :only_integer => true,
  :greater_than => 99, :less_than => 1000, :message => "should be 3 digits"
  validates :expiration_date, presence: true

  #Lets the user model to be rateable with the max rating of 5 stars. Links the user model to the rate model.
  #The dimension specifies a spec/feature for which the rating is given.
  ajaxful_rateable :stars => 5, :dimensions => [:rating]
  #Allows users to rate other users
  ajaxful_rater

  #The method generates a random remember token. It is called just before the user is saved
  private
    def create_remember_token
      self.remember_token=SecureRandom.urlsafe_base64
    end

end
