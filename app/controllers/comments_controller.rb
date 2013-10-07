class CommentsController < ApplicationController
	before_filter :signed_in_user, only: [:create, :destroy]

  def create
  	@item = Item.find(params[:comment][:item_id])
  	@comment = @item.comments.build(params[:comment])
  	@comment.user_id = current_user.id
  	if @comment.save!
  		@number = Comment.count
  		respond_to do |format|
  			format.html {redirect_to @item}
  			format.js
  		end
  	end
  end

  def destroy
    @item=Comment.find(params[:id]).commented_item
    Comment.find(params[:id]).destroy
    # flash[:success]="Comment was deleted"
    respond_to do |format|
      format.html {redirect_to @item}
      format.js
    end
  end

end
