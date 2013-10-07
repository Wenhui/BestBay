require 'spec_helper'

describe Item do
  let(:user) { FactoryGirl.create(:user, :userName => "Josh", :email => "Josh@cmu.edu.com") }

  before  do
    @category = Category.create(:name => "home")
    @item = FactoryGirl.create(:item, user: user)
    @item.categories << @category
  end
  subject { @item }

  it {should respond_to(:name)}
  it {should respond_to(:description)}
  it {should respond_to(:user_id)}
  it {should respond_to(:start_price)};
  it {should respond_to(:reserve_price)};
  it {should respond_to(:bid_time)};
  it {should respond_to(:auction_end)};
  it {should respond_to(:category_ids)};
  its(:user) { should == user}


  it { should be_valid}
  it {should respond_to(:categories)}
  it {should respond_to(:watchers)}
  it {should respond_to(:bidders)}
  it {should respond_to(:bids)}
  its(:auction_end) { should be_instance_of(ActiveSupport::TimeWithZone) }

  describe "watchers" do
     it "should have watchers" do
    @user2 = FactoryGirl.create(:user, :userName => "mellon", :email => "mellon@cmu.edu.com")
    subject { @item }
    @item.watchers.should be_empty

    @item.watchers << @user2
    @item.save!
    @item.watchers.should include(@user2)
  end
  end

  describe "accessible attributes" do
  	it "should not allow access to user_id" do
  		expect { Item.new(user_id: user.id)}.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
  	end
  end

  describe "it should have categories" do
    it "have " do
      @item.categories.first.name.should == @category.name
    end
  end

  describe "user_id is not present" do
  	before {@item.user_id = nil}
  	it { should_not be_valid }
  end

  describe "with blank name" do
  	before { @item.name = nil }
  	it {should_not be_valid }
  end

  describe "with blank description" do
  	before { @item.description = nil }
  	it { should_not be_valid }
  end

  # describe "with long description" do 
  # 	before { @item.description = "a" * 202}
  # 	it {should_not be_valid }
  # end

  describe "with negative start_price" do
  	before { @item.start_price = -1 }
  	it { should_not be_valid }
  end

  describe "with negative reserve_price" do
  	before { @item.reserve_price = -1 }
  	it { should_not be_valid }
  end

  describe "expired? should be true if auction_end is less than now" do
    before{@item.auction_end = DateTime.now - 2.hour}
    it {should be_expired }
  end

  describe "expired? should be false if auction_end is more than now" do
    before{@item.auction_end = DateTime.now + 5.hour}
    it {should_not be_expired }
  end

end
