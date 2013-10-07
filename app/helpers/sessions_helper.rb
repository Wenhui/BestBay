module SessionsHelper

  def sign_in(user)
    cookies.permanent[:remember_token]=user.remember_token
    self.current_user=user
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    self.current_user=nil
    cookies.delete(:remember_token)
  end

   def signed_in_user
    unless signed_in?
      store_location
      flash[:error] = "Please sign in."
      redirect_to signin_url 
    end
  end

  def current_user=(user)
    @current_user=user
  end

  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  def current_user?(user)
    user == current_user
  end

   def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url
  end

  def calculateNotifications
    @notificationNum = 0

    current_user.items.each do |item|
      if item.notified? == false && item.name.length > 0
        @notificationNum += 1
      end
    end

    current_user.bids.each do |bid|
      if bid.notified? == false 
        @notificationNum += 1
      end
      if bid.inbid? == true
        item = Item.find(bid.item_id)
        if bid.price < item.highest_price
          @notificationNum += 1
        end
      end
    end
    @notificationNum
  end

end
