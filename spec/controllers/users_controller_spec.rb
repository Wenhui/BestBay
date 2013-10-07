require 'spec_helper'


describe UsersController do

  let(:user)  { FactoryGirl.create(:user) }

  def stub_signed_in_user
    UsersController.any_instance.stub(:signed_in_user).and_return(true)
    UsersController.any_instance.stub(:correct_user).and_return(true)
    UsersController.any_instance.stub(:active_user).and_return(false)
  end

  def stub_admin
    UsersController.any_instance.stub(:admin_user).and_return(true)
  end

  def stub_current_user
    UsersController.any_instance.stub(:current_user).and_return(user)
  end

  def stub_sign_in
    UsersController.any_instance.stub(:signed_in?).and_return(true)
    UsersController.any_instance.stub(:store_location).and_return(true)
  end

  def stub_not_sign_in
    UsersController.any_instance.stub(:signed_in?).and_return(false)
    UsersController.any_instance.stub(:store_location).and_return(true)
  end

  def mock_user(stubs={})
      @mock_user ||= mock_model(User, stubs)
  end


  before (:each) do
    @user = FactoryGirl.create(:user)
  end

  describe "GET 'show'" do
    
    it "should be successful" do
      stub_signed_in_user
      get :show, :id => @user.id
      response.should be_success
    end
    
    it "should find the right user" do
      stub_signed_in_user
      get :show, :id => @user.id
      assigns(:user).should == @user
    end

    it "without signed in, should fail" do
      get :show,{:id => @user.id }
      response.should_not be_success
    end

    it "should be deactive after admin deactivate a user" do
      stub_signed_in_user
      get :show, :id => @user.id, :active => false
      response.should be_success
    end

    it "should be active after admin activate a user" do
      stub_signed_in_user
      get :show, :id => @user.id, :active => true
      response.should be_success
    end

  end

  describe "GET 'new' " do
    it "assigns a new user" do
      User.stub!(:new).and_return(mock_user)
      get :new
      assigns[:user].should eq(mock_user)
    end
  end
  

  describe "GET 'index' " do

    it "should render template" do
      stub_admin
      get :index
      response.should be_success
    end

    it "should be successful" do
      stub_signed_in_user
      get :edit, :id => @user.id
      response.should be_success
    end
  end


  describe "POST 'create'" do

    it "should be successful" do
      post :create, :user => { 
        :userName => 'Joy', 
        :email =>'user@user.com', 
        :password => "123456",
        :password_confirmation => "123456",
        :address => "Mountain View",
        :birthdate => '2001-02-03',
        :security_num => "111",
        :expiration_date => '2001-02-03'
      }
      response.should be_success
    end


    it "should be successful" do
      post :create, :user => { 
        :userName => 'Joy', 
        :email =>'user@user.com', 
        :password => "123456",
        :password_confirmation => "123456",
        :expiration_date => '2001-02-03'
      }
      response.should render_template("new")
    end
  end

  describe "PUT 'update' " do

    it "located the requested @user" do
          stub_signed_in_user
          put :update, :id => @user, user: FactoryGirl.attributes_for(:user)
          assigns(:user).should eq(@user)      
        end

    it "should update an attribute successfully " do
      stub_signed_in_user
      put :update, :id => @user.id, user: FactoryGirl.attributes_for(:user, userName: "Larry Smith")
      @user.reload
      @user.userName.should eq("Larry Smith")
    end

  end

  describe "DELETE 'destroy' " do 

    it " should delete user " do
      stub_admin
      User.should_receive(:find).with("17").and_return(mock_user)
      mock_user.should_receive(:destroy)
      delete :destroy, :id => "17"
    end

  end

  describe "Get " do

    it "should respond to profile" do
      get :profile, :id => user.id
      response.should be_success
    end

    it "should respond to rate" do
      get :rate, :id => user.id,:format => 'js'
      response.should be_success
    end

    it "should respond to watchlist" do
      stub_current_user
      get :watchlist
      response.should be_success
    end

    it "should respond to deactive" do
      stub_admin
      get :deactive, :id => user.id
      response.should redirect_to(users_path)
    end

    it "should respond to active" do
      stub_admin
      user.active = false
      user.save
      get :deactive, :id => user.id
      response.should redirect_to(users_path)
    end

  end

  describe "private method test" do
    before(:each) do
      @controller = UsersController.new
    end
    it "signed_in_user" do
      stub_sign_in
      @controller.send(:signed_in_user)
      response.should be_success
    end
  end

end

    
