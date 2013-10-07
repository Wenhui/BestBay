require 'spec_helper'

describe Bid do

  let(:user) { FactoryGirl.create(:user, :userName => "Josh", :email => "Josh@cmu.edu.com") }
  let(:item) { FactoryGirl.create(:item, user: user)}
  let(:bid) {FactoryGirl.create(:bid, user_id: user.id, item_id: item.id)}

  subject { @bid }

  describe "invalid bid" do
    before { @bid=Bid.new }

	  it { should_not be_valid }

     it "should not be valid if price is nil" do
      bid.price = nil
      bid.should_not be_valid
     end

     it "should not be valid if price is less than 0" do
      bid.price = -1
      bid.should_not be_valid
     end

     it "should not be valid if user_id is nil" do
      bid.user_id = nil
      bid.should_not be_valid
     end

     it "should not be valid if item_id is nil" do
      bid.item_id = nil
      bid.should_not be_valid
     end

  end


  describe "valid bid" do

    before(:each) do
       @bid = Bid.new(user_id: user.id, item_id: item.id, price: 2.5 )
    end

    it { should belong_to :bidder }
    it { should belong_to :bid_item }

    it {should respond_to(:notifiy)}
    it {should respond_to(:bidder)}
    it {should respond_to(:bid_item)}
    it {should respond_to(:inBid_notify)}
    it {should respond_to(:price)}
    it { should be_valid }

    its(:bidder) { should == user}
    its(:bid_item) { should == item}

    it "should notify user" do
       @bid.notified?.should be_true
    end

    it "should notify user" do
      @bid.notifiy = false
      item.auction_end = DateTime.now - 100.hour
      item.save
      @bid.save
      @bid.notified?.should be_false
    end

    it "should be in bid" do
      @bid.inbid?.should be_true
    end

    it "should not in bid" do
      @bid.inBid_notify = true
      @bid.inbid?.should be_false
    end


  end


end
