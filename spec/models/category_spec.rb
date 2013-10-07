require 'spec_helper'

describe Category do
  let(:category) { Category.new }
  #@category=Category.new
  subject { category }

  it { should_not be_valid }

  it{should respond_to(:name)}

  it "is valid with a name" do
    category.name = "car"
    category.save
    category.should be_valid
  end

  before do
    @user=FactoryGirl.create(:user)
    @item=FactoryGirl.create(:item, user: @user)

    category.items << @item
    category.save
  end

  it {should respond_to(:items)}

  it "should have the assigned item" do
    category.items(force_reload=true).find_by_name(@item.name)
  end


end

