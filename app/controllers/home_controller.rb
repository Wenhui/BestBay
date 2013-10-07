class HomeController < ApplicationController
#transfer ruby into html language to view, then to browser
  def index

  if current_user != nil
    @notificationNum=calculateNotifications

  end

    if (params[:id] != nil)
    #get category id  
    @category = Category.find(params[:id])
      respond_to do |format|
        format.html
        format.js
      end
    else
      respond_to do |format|
        format.html
      end
    end 
end

#respond to the user's action: click on the X with a notification
#Set the bid's notify to true, so the notification will disappear
  def closedBidNotified
    bid = Bid.find(params[:id])
    bid.notifiy = true
    bid.save!
    respond_to do |format|
        format.html
        format.js
    end
  end

  def inBidNotified
    bid = Bid.find(params[:id])
    bid.inBid_notify = true
    bid.save!
    respond_to do |format|
        format.html
        format.js
    end
  end

  def postedNotified
    item = Item.find(params[:id])
    item.notificated = true
    item.save!
    respond_to do |format|
      format.html
      format.js
    end
  end



end
