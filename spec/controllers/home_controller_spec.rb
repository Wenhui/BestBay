require 'spec_helper'

describe HomeController do

	let(:user)  { FactoryGirl.create(:user) }
	let(:item)  { FactoryGirl.create(:item, user: user, created_at: 1.hour.ago) }
	let(:bid) {FactoryGirl.create(:bid, user_id: user.id, item_id: item.id)}

	describe "index display" do
		it "should be successful" do
			get :index
			response.should be_success
		end

		it "should response to category request" do
			get :index, :id => 1, :format => 'js'
			response.should be_success
		end
	end

	describe "closed bid notification" do
		it "should be successful" do
			get :closedBidNotified, :id => bid.id, :format => 'js'
			response.should be_success
		end
	end

	describe "in bid notification" do
		it "should be successful" do
			get :inBidNotified, :id => bid.id, :format => 'js'
			response.should be_success
		end
	end

	describe "posted item notification" do
		it "should be successful" do
			get :postedNotified, :id => item.id, :format => 'js'
			response.should be_success
		end
	end


end
