require 'spec_helper'

describe User do
  subject { page }

  describe "user register page" do

  before(:each) { visit new_user_path }
  let(:submit) { "Register" }

  describe "when user information is not valid" do

      it "should not add a user to the database " do
        expect { click_button submit }.not_to change(User, :count)
      end
  end

  describe "when user information is valid" do

      before do

        fill_in "user_userName",    with: "TestUser"
        fill_in "user_email",   with: "rrr@ex.com"
        fill_in "user_password",     with: "20122012"
        fill_in "user_password_confirmation",    with: "20122012"
        fill_in "user_address", with: "Test Address"
        fill_in "user_card_number", with: "1111111111111111"
        fill_in "user_security_num", with: "111"


      end

      it "should create a user", debug: true do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      it "should not create a user with the same information" do
        visit new_user_path
        expect { click_button submit }.not_to change(User, :count)
      end
   end

   describe "when user information is valid" do

     before(:each) do
       visit new_user_path
       fill_in "user_userName",    with: "TestUser2"
       fill_in "user_email",   with: "rrr2@ex.com"
       fill_in "user_password",     with: "20122012"
       fill_in "user_password_confirmation",    with: "20122011"
       fill_in "user_address", with: "Test Address"
       fill_in "user_card_number", with: "1111111111111111"
       fill_in "user_security_num", with: "111"


     end

     it "should not create a user if password confirmation does not match password" do
       expect { click_button submit }.not_to change(User, :count)
     end

     it "should not create a user if email is invalid" do

       fill_in "user_userName",    with: "TestUser1"
       fill_in "user_email",   with: "rrr@excom"
       fill_in "user_password_confirmation",    with: "20122012"
       expect { click_button submit }.not_to change(User, :count)
     end

     it "should not create a user if the credit card number is less than 16 digits" do
       fill_in "user_card_number", with: "11111111"
       expect { click_button submit }.not_to change(User, :count)
     end

     it "should not create a user if the credit card number is more than 16 digits" do
       fill_in "user_card_number", with: "111111111111111111"
       expect { click_button submit }.not_to change(User, :count)
     end 

     it "should not create a user if the security_num is less than 3 digits" do
       fill_in "user_security_num", with: "11"
       expect { click_button submit }.not_to change(User, :count)
     end

     it "should not create a user if the security_num is more than 3 digits" do
       fill_in "user_security_num", with: "1111"
       expect { click_button submit }.not_to change(User, :count)
     end
   end
  end

  describe "admin pages" do

    let(:admin) { FactoryGirl.create(:admin) }

    before(:all) { 10.times { FactoryGirl.create(:user) }}
    after(:all) { User.delete_all }



    describe "admin profile page" do
      before do
        sign_in admin
        visit root_path
      end

      it { should have_content("Hi Boss #{admin.userName}")}
      it { should have_link("Profile", href: user_path(admin)) }
      it { should have_link("List Users",href: users_path)}
    end

    describe "admin list of users page" do
        before(:each) do
          sign_in admin
          visit users_path
        end

        it "should deactivate a user when click on deactivate" do
          expect{ click_link "Deactivate"}.to change(User,:count).by(0)
        end
          
        it "should activate a user when click on Active" do
          User.all.each do |user|
            if user.active == false
              expect{ click_link "Activate"}.to change(User,:count).by(1)
            end
          end
        end

        it {should have_selector('h1', text:"All users")}
            it "should list all the users and have a link to delete" do
              User.paginate(page: 1, per_page: 10).each do |user|
                if !user.admin?
                  page.should have_selector('li',text: user.userName)
                  page.should have_link('Delete', href: user_path(user))
                end
              end
            end

            it "should delete a user when delete link is clicked" do
              expect{ click_link "Delete"}.to change(User,:count).by(-1)
            end

        end

    end

end
    #describe "when book information is valid and a comment is added" do
    #  before do
    #    fill_in "Title",    with: "Example book 3"
    #    fill_in "Author",   with: "Example author"
    #    fill_in "Year",     with: "2012"
    #    fill_in "Genre",    with: "novel"
    #    fill_in "commentArea", with: "This is a valid comment"
    #
    #  end
    #
    #  it "should create a book " do
    #    expect { click_button submit }.to change(Book, :count).by(1)
    #  end
    #
    #  it "should create a comment" do
    #
    #    expect { click_button submit }.to change(Comment, :count).by(1)
    #
    #  end
    #
    #end
#end
