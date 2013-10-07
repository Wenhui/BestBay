require 'spec_helper'
# require 'User'

describe User do

  before(:each) do
      @user = User.new(
          :userName => "Josh",
          :email => "Josh@cmu.edu",
          :password => "123456",
          :password_confirmation => "123456",
          :address => "Mountain View",
          :birthdate => '2001-02-03',
      :card_number => "1"*16,
      :security_num => "111",
      :expiration_date => '2001-02-03')
    end

    it "is valid with valid attributes" do
      @user.should be_valid
    end

    it "is not valid without a userName" do
      @user.userName = nil
      @user.should_not be_valid
    end

    it "is not valid without an email" do
      @user.email = nil
      @user.should_not be_valid
    end

    it "is not valid without address" do
      @user.address = nil
      @user.should_not be_valid
    end

    it "is not valid without birthdate" do
      @user.birthdate = nil
      @user.should_not be_valid
    end

    it "is not valid without password" do
      @user.password = nil
      @user.should_not be_valid
    end

    it "is not valid without password_confirmation" do
      @user.password_confirmation = nil
      @user.should_not be_valid
    end

    it "is not valid without expiration date" do
      @user.expiration_date = nil
      @user.should_not be_valid
    end

    it "is not valid if the password is less than 6 digits" do
      @user.password = "12345"
      @user.should_not be_valid
    end

    it "is not valid if the password doesn't match the password_confirmation" do
      @user.password = "111111"
      @user.should_not be_valid
    end


    it "is not valid if the userName is longer than 50 letters" do
      @user.userName =  "josh" * 100
      @user.should_not be_valid
    end

    it "is not valid if the email is not right formatted" do
          @user.email="www.qwerd.ccc"
          @user.should_not be_valid
    end


    it "is not valid if the credit card number is not numerical" do

      @user.card_number = "1"*15+"r"
      @user.should_not be_valid
    end


    it "is not valid if the security number is not numerical" do
      @user.security_num = "1"*2+"r"
      @user.should_not be_valid
    end


    it "is not valid if the credit card number doesn't have 16 digits" do
      @user.card_number = "1"*17
      @user.should_not be_valid
    end


    it "is not valid if the security number doesn't have 3 digits" do
      @user.security_num = "1"*4
      @user.should_not be_valid
    end


    before(:each) do

      @user.save

      @user2 = User.new(
          :userName => "Hui",
          :email => "Josh@cm.edu",
          :password => "123456",
          :password_confirmation => "123456",
          :address => "Mountain View",
          :birthdate => '2001-02-03',
          :card_number => "1"*16,
          :security_num => "111",
          :expiration_date => '2001-02-03')

    end

    it "is not valid if the email address is not unique" do
        @user2.email= "Josh@cmu.edu"
        @user2.should_not be_valid

    end

    it "is not valid if the userName is not unique" do
         @user2.userName="Josh"
         @user2.should_not be_valid
    end

    it "should not be admin" do
      @user.should_not be_admin
    end

    it "has a remember_token" do
      @user.remember_token.should_not be_blank
    end

  subject { @user }

  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:items)}
  it {should respond_to(:watched_items)}
  it {should respond_to(:bids)}
  it {should respond_to(:bid_items)}


  describe "user watch list" do

  it "should have watched_items" do
    @user = FactoryGirl.create(:user, :userName =>"ca", :email => "hello@world.com")
    @item = FactoryGirl.create(:item, user:@user)
    @user2 = FactoryGirl.create(:user, :userName => "mellon", :email => "mellon@cmu.edu.com")
    subject { @user2 }
    @user2.watched_items.should be_empty

    @user2.watched_items << @item
    @user2.save!
    @user2.watched_items.should include(@item)
  end

  end 

  describe "item associations" do
    let!(:older_item) do
      FactoryGirl.create(:item, user: @user, created_at: 1.day.ago)
    end

    let!(:newer_item) do
      FactoryGirl.create(:item, user:@user, created_at: 1.hour.ago)
    end

    it "should have the right order of the items" do
      @user.items.should == [newer_item, older_item]
    end

    it { should respond_to(:password_confirmation) }
    it { should respond_to(:remember_token) }
    it { should respond_to(:authenticate) }

    it "can be changed to admin" do
        @user.admin=true
        @user.should be_admin
    end

    

    it "should destroy associated items" do
      items = @user.items.dup
      @user.destroy
      items.should_not be_empty
      items.each do |item|
        Item.find_by_id(item.id).should be_nil
      end
    end
  end
end
