class UsersController < ApplicationController

  # only sign in user can see their profile and make change to it
  before_filter :signed_in_user, only: [:edit, :update, :show] 

  before_filter :correct_user,   only: [:edit, :update, :show]

  # Judge whether the user has authorization to index and destroy all users
  before_filter :admin_user, only: [:index, :destroy, :deactive]

  # only active user can update his/her profile
  before_filter :active_user, only: [:edit, :update ]

  # For controller to transfer ruby into html from model
  # Get all users
  def index
    @users = User.all.paginate(page: params[:page], per_page: 10)
  end

  # Have a new user
  def new
    @user=User.new
  end

  # Show user by user_id
  def show
    @user=User.find(params[:id])
    @items = @user.items
  end

  # Find user by its id and render the edit view
  def edit
    @user=User.find(params[:id])
  end

  # Build the new user and then save it
  def create
    @user=User.new(params[:user])

    if  @user.save
      sign_in @user
      redirect_to @user
    else
      render 'new'
    end
  end

  # Gets user by user id and get new info. for user
  def update
    @user=User.find(params[:id])
    if  @user.update_attributes(params[:user])
      sign_in @user
      redirect_to @user , :notice => "Profile Updated" #, notice: "User was successfully updated" }
    else render 'edit'

    end
  end

  # Find user by id and destroy it then redirect to root_url
   def destroy
    user = User.find(params[:id])
    user.destroy
    flash[:error] = "Delete User #{user.userName}"
    redirect_to '/users'
  end

  # rate the seller 
  def rate
    @user = User.find(params[:id])
    @user.rate(params[:stars], current_user, params[:dimension])
    respond_to do |format|
      format.js
    end
  end

  # invoke user's profile to public
  def profile
    @user = User.find(params[:id])
  end

  # Connect the watch list view with corresponding user
  def watchlist
    @items=current_user.items.paginate(page: params[:page], per_page: 10)
    @bid_items=current_user.bid_items.paginate(page: params[:bid_page], per_page: 10)
    @watched_items=current_user.watched_items.paginate(page: params[:watched_page], per_page: 10)
    respond_to do |format|
      format.html
      format.js
    end
  end

  # administrator can deactive and activate user
  def deactive
   user = User.find(params[:id])
   user.toggle!(:active)
   user.save
    if user.active == true 
      redirect_to users_path, :notice => "Activate User #{user.userName}"
    else 
      flash[:error] = "Deactivate User #{user.userName}"
      redirect_to users_path 
    end
  end 

   private
    # Judge whether current person is signed-in user
     def signed_in_user
      unless signed_in?
        store_location
        flash[:error] = "Please sign in."
        redirect_to signin_url 
      end
    end

    # Judge whether current user is admin or has the right user_id
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless (current_user.admin? == true || current_user?(@user)) 
    end

    # Judge whether it is admin_user
    def admin_user
      redirect_to(root_path) unless (current_user != nil && current_user.admin == true)
    end

    # Judge whether the user is currently activated
    def active_user
      redirect_to(root_path) unless (current_user != nil && current_user.active == true)
    end

end

