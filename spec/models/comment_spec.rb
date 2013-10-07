require 'spec_helper'

describe Comment do
  let(:user) { FactoryGirl.create(:user, :userName => "Josh", :email => "Josh@cmu.edu.com") }

  before  do
    @item = FactoryGirl.create(:item, user: user)
    @comment=FactoryGirl.create(:comment, user_id: user.id, item_id: @item.id)
  end
  subject { @comment }

  it {should be_valid}
  it {should respond_to(:content)}
  it {should respond_to(:user_id)}
  it {should respond_to(:item_id)}
  it {should respond_to(:commenter)}
  it {should respond_to(:commented_item)}
end
