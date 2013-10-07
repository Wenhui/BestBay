require 'spec_helper'

describe SessionsController do

	let(:user)  { FactoryGirl.create(:user) }

	describe "GET new" do
		it "should be successful" do
			get :new
			response.should be_success
		end
	end

	describe "Post create" do
		it "should be successful" do
			post :create, :session => {'email' => "wrong email", 'password' => user.password}
			assigns(user).should render_template("new")
		end

		it "should be successful" do
			post :create, :session => {'email' => user.email, 'password' => user.password}
			response.should redirect_to(root_path)
		end
	end

	describe "DELETE destroy" do
		it "should be successful" do
			delete :destroy
			response.should redirect_to(root_path)
		end
	end

end