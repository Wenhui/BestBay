require 'spec_helper'


describe Item do



  subject { page }
  let(:user) { FactoryGirl.create(:user) }
  before(:each) { sign_in user }

  describe "post item" do

  	before(:each) { visit new_item_path }

  	describe "when item information is not valid" do

      it "should not add item to the database " do
        expect { click_button "Post Item" }.not_to change(Item, :count)
      end

  	end

  	describe "with valid information" do

      before do 
        fill_in 'item_description', with: " blablabla "
        fill_in "item_name", with: "blablabla"
        fill_in "item_reserve_price", with: "123"
        fill_in "item_start_price", with: "123"
        fill_in "item_bid_time", with: "12"


      end
      
      it "should post an item" do
        expect { click_button "Post Item" }.to change(Item, :count).by(1)
      end

      it "should not belong to any category" do
         click_button "Post Item" 
         @category_ids.should be_nil
      end


      # it "check box is all unchecked" do
      #    # attribute[:category_ids] = nil
      #    # with_attribute (:type => :checkbox)
      #    # click_button "Post Item"
      #    # @item.should have_checkbox not_checked
      # end


    end



  end

  describe "Add item to watch list" do
    before(:all){

      @user= FactoryGirl.create(:user)
      @user2=FactoryGirl.create(:user)

      10.times{ FactoryGirl.create(:item, user: @user) }
      @item=@user.items.first

    }

    after(:all) { User.delete_all
    Item.delete_all
    }

    it "should have a button for adding the item to watch list" do
      visit item_path(@item)
      page.should have_link("Add to watch list")
    end

    it "should add an item to user's watch list when clicked" do
      sign_in(@user2)
      visit item_path(@item)
      expect{click_link("Add to watch list")}.to change(@user2.watched_items,:count).by(1)
    end

    it "should not have the link to watch list for the watched item" do
      sign_in(@user2)
      visit item_path(@item)
      click_link("Add to watch list")
      page.should_not have_link("Add to watch list")
      page.should have_link("Remove from watch list")
    end

    it "should not have a button for the posted item to add to the user's watch list" do
      sign_in(@user)
      visit item_path(@item)
      page.should_not have_link("Add to watch list")
    end

    it "should delete the item from watch list when clicked" do
      sign_in(@user2)
      visit item_path(@item)
      click_link("Add to watch list")
      expect{click_link("Remove from watch list")}.to change(@user2.watched_items,:count).by(-1)
    end

  end

  describe "bid on an item" do


     before(:all){

      @user= FactoryGirl.create(:user)
      @user2=FactoryGirl.create(:user)

      10.times{ FactoryGirl.create(:item, user: @user) }
      @item=@user.items.first

  

    }

    after(:all) { User.delete_all
    Item.delete_all
    }

    it "should have a button for bidding an item" do
      visit item_path(@item)
      page.should have_button("Bid It Now")
    end

    it "should accept a bid on an item when the Bid is valid" do
      sign_in(@user2)
      visit item_path(@item)
      fill_in "price", with: 10
      expect{click_button("Bid It Now")}.to change(@user2.bid_items,:count).by(1)
    end

    it "should not see the bid button when the item is posted by the user" do
      sign_in(@user)
      visit item_path(@item)
      page.should_not have_button("Bid It Now")
    end

    it "should not make a bid when enter a illegal string" do
       sign_in(@user2)
       visit item_path(@item)
       fill_in "price", with: "sdf"
       expect { click_button "Bid It Now" }.not_to change(Bid, :count)
    end

    it "should not make a bid when enter a lower price than current price" do
       sign_in(@user2)
       visit item_path(@item)
       @item.highest_price = 100;
       fill_in "price", with: 10
       click_button "Bid It Now" 
       @item.highest_price.should_not == 10
    end

     it "should not make a bid when the time is out" do
       sign_in(@user2)
       visit item_path(@item)
       fill_in "price", with: 1000
       @item.auction_end=DateTime.now-1.hour
       @item.save
       expect { click_button "Bid It Now" }.not_to change(Bid, :count)
     end

     it "should not display the bid button if the auction is closed" do
       sign_in(@user2)
       @item.auction_end = DateTime.now - 1.hour
       @item.save
       visit item_path(@item)
       page.should_not have_button("Bid It Now")
     end

     it "should not display the delete button if there has a highest_price 
     higher than item_reserve_price" do
       sign_in(@user2)
       if @item.highest_price >= @item.reserve_price
          visit item_path(@item)
          page.should_not have_button("Delete")
       end
     end
  end



end

