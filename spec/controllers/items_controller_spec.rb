require 'spec_helper'


describe ItemsController  do

	let(:user)  { FactoryGirl.create(:user) }
	let(:item)  { FactoryGirl.create(:item, user: user, updated_at: 1.hour.ago) }
	let(:item2) {FactoryGirl.create(:item, user: user, start_price: 100, created_at: 2.hour.ago)}
	let(:items) {[item]}

	def valid_attr
		{
			:name => "dog",
  			:description => "This is a dog",
    		:start_price  => 1.5,
   			:reserve_price => 1.5,
            :auction_end  => DateTime.now+12.hours,
		}
	end

	def stub_signed_in_user
		ItemsController.any_instance.stub(:signed_in_user).and_return(true)
	end

	def stub_session_helper
		ItemsController.any_instance.stub(:current_user).and_return(user)
	end

  def stub_current_user
    UsersController.any_instance.stub(:current_user).and_return(user)
  end


  describe "GET index" do
    it "should be successful" do
      controller.stub!(:admin_user).and_return(true)
      get :index
      response.should be_success
    end
  end


	describe "GET Show" do
		it "should be successful" do
			get :show, :id => item.id
			response.should be_success
		end
	end

	describe "GET edit" do
		it "assigns the requested item should be false with no signed in" do
			get :edit, {:id => item.to_param}
			response.should_not be_success
			assigns(:item).should_not eq(item)	
		end

		it "assigns the requested item should be true" do
     controller.stub!(:signed_in_user).and_return(true)
     controller.stub!(:correct_user).and_return(true)
     controller.stub!(:active_user).and_return(true)
     Item.should_receive(:find).with(item.to_param).and_return(item)
		 get :edit, :id => item.id

		end
	end

	describe "Post create" do
		before do 
			stub_signed_in_user
			stub_session_helper
		end

		describe "with valid params" do
			it "creates a new Item" do
			expect {
				post :create, :item => valid_attr
			}.to change(Item, :count).by(1)
			end

			it "assigns a newly created item as @item" do
				post :create, :item => valid_attr
				assigns(:item).should be_a(Item)
			end

			it "redirects to the created post" do
				post :create, :item => valid_attr
				response.should redirect_to(Item.last)
			end

			# it "should have 9 unchecked box in category" do
			# 	post :create, :item => valid_attr
			# 	response.should have_tag("input[type=checkbox]", 9)
			# end

			it "should belong to no category by default " do
				post :create, :item => valid_attr
				assigns(:category_ids).should nil
			end

		end

		describe "with invalid params" do
			it "assigns a newly created bu unsaved item" do
				Item.any_instance.stub(:save).and_return(false)
				post :create, :item => valid_attr
				assigns(:item).should be_a_new(Item)
			end

			it "re-renders the new template" do
				Item.any_instance.stub(:save).and_return(false)
				post :create, :item => valid_attr
				assigns(:item).should render_template("new")
			end 
		end
	end

	describe "PUT update" do

		before do 
			stub_signed_in_user
			stub_session_helper
		end

    describe "with valid params" do

      # it "updates the requested item" do
      # 	item = FactoryGirl.create(:item, user: user, created_at: 1.hour.ago)
      #   Item.any_instance.should_receive(:update_attributes).with({'name' => 'params'})
      #   put :update, {:id => item.to_param, :item => {'name' => 'params'}}
      # end

      it "assigns the requested item" do
        put :update, {:id => item.to_param, :item => valid_attr}
        assigns(:item).should eq(item)
      end

      it "redirects to the post" do
        put :update, {:id => item.to_param, :item => valid_attr}
        response.should redirect_to(item)
      end
    end

    describe "with invalid params" do
      it "assigns the post as @post" do
        Item.any_instance.stub(:save).and_return(false)
        put :update, {:id => item.to_param, :item => {}}
        assigns(:item).should eq(item)
      end
    end
  end

  describe "DELETE destroy" do

  		before do 
			stub_signed_in_user
			stub_session_helper
		end

    it "destroys the requested item" do
      item = FactoryGirl.create(:item, user: user, created_at: 1.hour.ago)
      expect {
        delete :destroy, {:id => item.to_param}
      }.to change(Item, :count).by(-1)
    end

    it "redirects to the posts list" do
      item = FactoryGirl.create(:item, user: user, created_at: 1.hour.ago)
      delete :destroy, {:id => item.to_param}
      response.should redirect_to(root_url)
    end
  end

  describe "Get something" do

    it "should respond to watch" do
      sign_in(user)
      get :watch, :id => item.id
      response.should redirect_to(item)
    end

  end

  describe "GET sort items by price" do
    before do
      20.times { FactoryGirl.create(:item, user: user, created_at: 1.hour.ago) }
      @ids=Item.all.collect { |item| item.id }
    end

    it "returns nil of all items" do
      get :allItems,{:items => nil }
      response.should be_successful
      response.should render_template('items/search')
    end

    it "returns the list of sorted items starting with lower price" do

      get :sortByPriceAs,{:items => @ids }
      response.should be_successful
      response.should render_template('items/search')
    end

    it "returns the list of sorted items starting with higher price" do

      get :sortByPriceDes,{:items => @ids }
      response.should be_successful
      response.should render_template('items/search')
    end

    it "returns the list of items sorted by auction end" do

      get :sortByAuctionEndAs,{:items => @ids }
      response.should be_successful
      response.should render_template('items/search')
    end

    it "returns the list of items sorted by auction end" do
      get :sortByAuctionEndAs,{:items => @ids }
      response.should be_successful
      response.should render_template('items/search')
    end

    it "returns the list of items sorted by auction end descending" do
      get :sortByAuctionEndDes,{:items => @ids }
      response.should be_successful
      response.should render_template('items/search')
    end

    it "returns the list of items sorted by creation time" do
      get :sortByCreateTime,{:items => @ids }
      response.should be_successful
      response.should render_template('items/search')
    end

    it "returns the list of all items" do
      get :allItems,{:items => @ids }
      response.should be_successful
      response.should render_template('items/search')
    end

  end

  describe "POST bid" do
    before do
      sign_in user
    end
    it "should redirect to the items page" do
      post :bid, {:id => item.to_param, :price => 2}
      response.should redirect_to(item)
    end

    it "should redirect to the items page in case of the failed bid" do
      post :bid, {:id => item.to_param, :price => 1}
      response.should redirect_to(item)
    end

    it "should redirect to the items page in case the auction is over" do
       item.auction_end=DateTime.now-1
       post :bid, {:id => item.to_param, :price => 1}
       response.should redirect_to(item)
    end

  end

  describe "get deactivate" do

    it "should save the item and redirect to the items page" do
      controller.stub!(:admin_user).and_return(true)
      Item.should_receive(:find).with(item.to_param).and_return(item)
      item.should_receive(:save).and_return(true)
      get :deactive, {:id => item.to_param }
      response.should redirect_to(items_path)
    end
  end
end



