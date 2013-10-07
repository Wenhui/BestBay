require 'spec_helper'

describe CommentsController do

  before :each do
    @user = FactoryGirl.create(:user)
    @item = FactoryGirl.create(:item, user: @user)
    @comment=FactoryGirl.create(:comment, user_id: @user.id, item_id: @item.id)
    controller.stub!(:signed_in_user).and_return(true)
    controller.stub!(:current_user).and_return(@user)
  end
  after(:all) { User.delete_all
                Item.delete_all
                Comment.delete_all
  }
  describe "POST 'create'" do
    it "returns http success" do
      Item.stub!(:find).and_return(@item)

      expect{
        post 'create', :comment => {content: @comment.content, user_id: @user.id}
      }.to change(Comment,:count).by(1)

    end
  end

  describe "DELETE" do
    it "deletes the comment" do
      #Comment.stub_chain(:find, :commented_item).and_return(@item)
      Comment.should_receive(:find).twice.and_return(@comment)
      expect{
        delete 'destroy', :id => @comment
      }.to change(Comment,:count).by(-1)
    end

    it "redirects to the item page" do
      #Comment.stub_chain(:find, :commented_item).and_return(@item)
      #Comment.should_receive(:find).and_return(@comment)
      delete 'destroy', id: @comment
      response.should redirect_to @item
    end
  end

end
