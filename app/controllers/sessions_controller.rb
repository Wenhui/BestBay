class SessionsController < ApplicationController

  # For view
  def new

  end

  # Build a session for user information tracking
  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
       sign_in user
       redirect_back_or root_url
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  # Delete all information when user sign out
  def destroy
    sign_out
    redirect_to root_url
  end
end
