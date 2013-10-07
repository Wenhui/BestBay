require 'spec_helper'

describe "home page" do
before(:all){

    @user= FactoryGirl.create(:user)
    @user2=FactoryGirl.create(:user)

    10.times{ FactoryGirl.create(:item, user: @user) }

    @item=FactoryGirl.create(:item, user: @user)
    @cat=Category.new(:name => "Books")
    @user2.watched_items <<  @user.items
    @cat.items << @user.items
    @user2.save!
  }


  it "should have categories" do
    visit "index"
    page.should have_content(@cat.name)
  end




  # it "should display posted items on the watch list" do
  #   visit root_path
  #   sign_in @user
  #   @user.items.each do |item|
  #     page.should have_content("Posted")
  #     page.should have_link("#{item.name}", href: item_path(item))
  #   end
  # end

  # it "should display watched items on the watch list" do
  #   @user2.watched_items << @user.items.first
  #   @user2.save!

  #   visit root_path
  #   sign_in @user2

  #   @user2.watched_items.each do |item|
  #     page.should have_content("Watched")
  #     page.should have_link("#{item.name}", href: item_path(item))
  #   end
  # end

  describe "search" do
    

    it "should return items defined by the key words after search" do
      
      visit root_path

      fill_in "search_field", with: "#{@item.name}" 

      click_button "Search" 

      page.should have_content "#{@item.name}"
      
    end

  end

  after(:all) { User.delete_all
                Item.delete_all
  }
end

