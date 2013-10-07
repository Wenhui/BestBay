# This is test for session
require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_selector('h1',    text: 'Sign in') }
  end

  describe "signin" do
    before { visit signin_path }

    # describe "with invalid information" do
    #   before { click_button "Sign in" }

    #   # it { flash.instance_variable_get(:@now).should_not be_nil }
    #   # flash.now[:message].should_not be_nil
    #   it { should have_selector(text: 'Invalid email/password combination') }



    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Email",    with: user.email
        fill_in "Password", with: user.password
        click_button "Sign in"
      end

      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end

    end
  end
end