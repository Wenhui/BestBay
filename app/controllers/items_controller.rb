class ItemsController < ApplicationController
  # Called signed_in_user method as long as 
  # methods new, create, edit and destroy are called by items
  before_filter :signed_in_user, only: [:new, :create,:edit, :destroy, :watch, :unwatch, :bid]

  # Required correct_user method so long as 
  # method edit and destroy is called by items
  before_filter :correct_user,   only: [:edit, :destroy]

  # deactivated user can not do anything except for see the item page
  before_filter :active_user, only: [:new, :create, :edit, :destroy, :watch, :unwatch, :bid]

  # only administrator can list all auctions and deactive which has not been timed out
  before_filter :admin_user, only: [:index, :deactive]

  # For controller to transfer ruby into html from model
  def index
    @items = Item.all.paginate(page: params[:page], per_page: 10)
  end

  # Have a new item and a category for items
  def new
    session[:return_to] = request.referer
    @item  = Item.new
    @categories = Category.all
  end

  # Build the new item in current_user.items and then save it
  def create

    @item = current_user.items.build(params[:item].except(:bid_time))

    # Calculate the end time of auction
    @item.auction_end=DateTime.now + params[:item][:bid_time].to_f.hours

    if @item.save
      redirect_to @item, :notice => "Item posted"
    else
      render new_item_path
    end
  end

  # Find item by its id and render the edit view
  def edit
    @item = Item.find(params[:id])
  end

  # Invoking Method setHighestPriceAndWinner to have the highest price 
  # of the item auction and the owner’s name
  def show
    @item = Item.find(params[:id])
    setHighestPriceAndWinner
    @comments = @item.comments.paginate(page: params[:page], per_page: 5)

  end

  # Gets item and user who has the item by item id and item.user_id
  def update
    @item= Item.find(params[:id])
    @user = User.find(@item.user_id)
    params[:item][:category_ids] ||= []
      if  @item.update_attributes(params[:item])
          redirect_to @item , :notice => "Item Updated"
      else render 'edit'
      end
  end

  # Find item by id and destroy it then redirect to root_url
  def destroy 
     item = Item.find(params[:id])
     item.destroy
     # item.bids.each do |bid|
     #  bid.destroy
     # end
     flash[:error] = "Delete Item #{item.name}"
     redirect_to root_url
  end

  # Create a watch for association between items and users
  def watch
    @item= Item.find(params[:id])
    Watch.create(user_id: current_user.id, item_id: @item.id)
    #current_user.watched_items << @item
    redirect_to @item, :notice => "Item Added to Watch List"
  end


  # An item can be removed from the watchlist
  def unwatch
    current_user.watches.find_by_item_id(params[:id]).destroy
    @item= Item.find(params[:id])
    #current_user.watched_items << @item
    flash[:error] = "Item Removed from Watch List"
    redirect_to @item
  end

  # deactivate an auction
  def deactive
   @item = Item.find(params[:id])
   @item.auction_end=DateTime.now 
   @item.save
   redirect_to items_path
  end 

  # Bid on an item
  def bid
    @item = Item.find(params[:id])
    setHighestPriceAndWinner

    # If auction_end.localtime > DateTime.now, users can bid this item.
    if (@item.auction_end.localtime > DateTime.now)
      @bid = @item.bids.find_by_user_id(current_user.id)
      if(@bid == nil)
        @bid = Bid.new(user_id: current_user.id, item_id: @item.id, price: params[:price])
        if(@bid.price != nil)
          if(@bid.price > @item.highest_price && @bid.price > @item.start_price)
            if @bid.save
              redirect_to @item, :notice => "Bid on an item"
            else
              flash[:error] = "Please bid with a price"
              redirect_to @item 
            end
          else
            flash[:error] = "Please bid with a higher price"
            redirect_to @item
          end
        else
          flash[:error] = "Please bid with a price"
          redirect_to @item 
        end

    # Several users have bid on the item and 
    # this new price will be compared to the original one to get the highest price
    else
         @bid.price = params[:price]
         if @bid.price != nil
           if @bid.price > @item.highest_price && @bid.price > @item.start_price
              setinBid_notify
              @bid.save!
              redirect_to @item, :notice => "Bid on an item"
           else
              flash[:error] = "Please bid with a higher price"
              redirect_to @item
           end
        else
          flash[:error] = "Please bid with a price"
          redirect_to @item
        end
      end
    else  
      flash[:error] = "Auction is over!!!"
      redirect_to @item 
    end
  end

  #render all items
  def allItems
    @items = Item.all
    paginateItems(@items)
    render 'items/search'
  end

  #sort the items according to their start_price in ascending order
  def sortByPriceAs
    @ids = params[:items]
    #@type = params[:type]
    index = 0
    @beforeSort = []
    @items = []
    until @ids[index] == nil
      item = Item.find(@ids[index])
      @beforeSort << item if item.expired? == false
      index = index + 1
    end
      @items = priceMergesortAs(@beforeSort)
     paginateItems(@items)
    render 'items/search'
  end

   #sort the items according to their start_price in descending order
  def sortByPriceDes
    @ids = params[:items]
    #@type = params[:type]
    index = 0
    @beforeSort = []
    @items = []
    until @ids[index] == nil
      item = Item.find(@ids[index])
      @beforeSort << item if item.expired? == false
      index = index + 1
    end
      @items = priceMergesortDes(@beforeSort)
    paginateItems(@items)
    render 'items/search'
  end

  #sort the items according to their aution_end time in ascending time
  def sortByAuctionEndAs
    @ids = params[:items]
    #@type = params[:type]
    index = 0
    @beforeSort = []
    @items = []
    until @ids[index] == nil
      item = Item.find(@ids[index])
      @beforeSort << item if item.expired? == false
      index = index + 1
    end
    @items = autionEndMergesortAs(@beforeSort)
    paginateItems(@items)
    render 'items/search'
  end

   #sort the items according to their aution_end time in descending time
  def sortByAuctionEndDes
    @ids = params[:items]
    #@type = params[:type]
    index = 0
    @beforeSort = []
    @items = []
    until @ids[index] == nil
      item = Item.find(@ids[index])
      @beforeSort << item if item.expired? == false
      index = index + 1
    end
    @items = autionEndMergesortDes(@beforeSort)
    paginateItems(@items)
    render 'items/search'
  end

  #sort the items according to their created_at time
  def sortByCreateTime
    @ids = params[:items]
    #@type = params[:type]
    index = 0
    @beforeSort = []
    @items = []
    until @ids[index] == nil
      item = Item.find(@ids[index])
      @beforeSort << item if item.expired? == false
      index = index + 1
    end
    @items = createTimeMergesort(@beforeSort)
    paginateItems(@items)

    render 'items/search'
  end

  # search function
    def search
        @items = Item.search(params[:search])
        paginateItems(@items)

    end

  private
    # determine if it's the correct user ?

    def correct_user
      @item = current_user.items.find_by_id(params[:id])
      @item = Item.find(params[:id]) if current_user.admin == true
      redirect_to root_url if @item.nil?
    end

    # determine if a user is activated
    def active_user
      # @item= Item.find(params[:id])
      # @item = current_user.items.find_by_id(params[:id])
      # @user = User.find(@item.user_id)
      redirect_to(root_path) unless (current_user != nil && current_user.active == true)
    end

    # determine if a user is admin
    def admin_user
      redirect_to(root_path) unless (current_user != nil && current_user.admin == true)
    end



    # Compare the highest_price and bid_price to get the highest one
    def setHighestPriceAndWinner
      @item = Item.find(params[:id])
      @highest_price = 0
      @winner_id = nil
      @item.bids.each  do |bid|
        if bid.price > @highest_price
          @highest_price = bid.price
          @winner_id = bid.user_id
        end
      end
      @item.highest_price = @highest_price
      @item.winner_id = @winner_id
      @item.save
    end

    #if a new bid is made, set all bids' inBid_notify to be false
    def setinBid_notify
      @item = Item.find(params[:id])
      @item.bids.each do |bid|
        bid.inBid_notify = false
      end
      @item.save!
    end

    #mergesort for start_price, type: true means ascending, false means descending
    def priceMergesortAs(items)
      return items if items.size <= 1
      mid = items.size/2
      left = items[0, mid]
      right = items[mid, items.size]
      priceMergeAs(priceMergesortAs(left), priceMergesortAs(right))
    end

    #mergesort for start_price, type: true means ascending, false means descending
    def priceMergesortDes(items)
      return items if items.size <= 1
      mid = items.size/2
      left = items[0, mid]
      right = items[mid, items.size]
      priceMergeDes(priceMergesortDes(left), priceMergesortDes(right))
    end

    #merge procedure in ascending order for start_price
    def priceMergeAs(left, right)
      sorted = []
      until left.empty? or right.empty?

        if left.first.highest_price != 0
          leftPrice = left.first.highest_price
        else
          leftPrice = left.first.start_price
        end

        if right.first.highest_price != 0
          rightPrice = right.first.highest_price
        else
          rightPrice = right.first.start_price
        end

        if leftPrice <= rightPrice
          sorted << left.shift
        else
          sorted << right.shift
        end
      end
      sorted.concat(left).concat(right)
    end

    #merge procedure in descending order for start_price
    def priceMergeDes(left, right)
      sorted = []
      until left.empty? or right.empty?

        if left.first.highest_price != 0
          leftPrice = left.first.highest_price
        else
          leftPrice = left.first.start_price
        end

        if right.first.highest_price != 0
          rightPrice = right.first.highest_price
        else
          rightPrice = right.first.start_price
        end

        if leftPrice >= rightPrice
          sorted << left.shift
        else
          sorted << right.shift
        end
      end
      sorted.concat(left).concat(right)
    end

    #mergesort for auction_end in ascending order
    def autionEndMergesortAs(items)
      return items if items.size <= 1
      mid = items.size/2
      left = items[0, mid]
      right = items[mid, items.size]
      autionEndMergeAs(autionEndMergesortAs(left), autionEndMergesortAs(right))
    end

    #mergesort for auction_end in descending order
    def autionEndMergesortDes(items)
      return items if items.size <= 1
      mid = items.size/2
      left = items[0, mid]
      right = items[mid, items.size]
      autionEndMergeDes(autionEndMergesortDes(left), autionEndMergesortDes(right))
    end


    #merge procedure in ascending order for aution_end
    def autionEndMergeAs(left, right)
      sorted = []
      until left.empty? or right.empty?
        if left.first.auction_end <= right.first.auction_end
          sorted << left.shift
        else
          sorted << right.shift
        end
      end
        sorted.concat(left).concat(right)
    end

    #merge procedure in descending order for aution_end
    def autionEndMergeDes(left, right)
      sorted = []
      until left.empty? or right.empty?
        if left.first.auction_end >= right.first.auction_end
          sorted << left.shift
        else
          sorted << right.shift
        end
      end
        sorted.concat(left).concat(right)
    end

    #mergesort for created time in descending order
    def createTimeMergesort(items)
      return items if items.size <= 1
      mid = items.size/2
      left = items[0, mid]
      right = items[mid, items.size]
      createTimeMerge(createTimeMergesort(left), createTimeMergesort(right))
    end

    #merge procedure for created time
    def createTimeMerge(left, right)
      sorted = []
      until left.empty? or right.empty?
        if left.first.created_at >= right.first.created_at
          sorted << left.shift
        else
          sorted << right.shift
        end
      end
        sorted.concat(left).concat(right)
    end

  #make items show in pagination
  def paginateItems(items)
    if !items.empty?
      @page_results=items.paginate(page: params[:page], per_page: 10)
    else @items=Item.all
    end

  end


end