require File.expand_path('../../spec_helper', __FILE__)
require 'atg_home_page'
require 'atg_login_register_page'
require 'atg_my_profile_page'
require 'atg_checkout_page.rb'

=begin
Verify that user can logout from Account Management, Catalog page and Checkout page successfully
=end

# initial variables
atg_home_page = HomeATG.new
atg_login_page = nil
atg_my_profile_page = nil
atg_checkout_page = nil
cookie_session_id = nil

# Account information
email = Data::EMAIL_EXIST_EMPTY_CONST
password = Data::PASSWORD_CONST

feature "TC07 - Account Management - Log out - ENV = '#{Data::ENV_CONST}' - Locale = '#{Data::LOCALE_CONST}'", js: true do
  # Go to Login page
  before :all do
    cookie_session_id = atg_home_page.load
    atg_login_page = atg_home_page.goto_login
  end

  context 'Print Session ID' do
    scenario '' do
      pending "***SESSION_ID: #{cookie_session_id}"
    end
  end

  context 'Log out from Account Management page' do
    scenario '1. Login to ATG' do
      atg_my_profile_page = atg_login_page.login(email, password)
    end

    scenario '2. Verify My Profile page displays' do
      expect(atg_my_profile_page.my_profile_page_exist?).to eq(true)
    end

    scenario '3. Click on Account Information link' do
      atg_my_profile_page.goto_account_information
    end

    scenario "4. Click on 'Log out' link on My Account navigation" do
      atg_home_page = atg_my_profile_page.logout
    end

    scenario '5. Verify user logout successfully' do
      expect(atg_home_page.logout_successful?).to eq(true)
    end
  end

  context 'Log out from App Center Catalog page' do
    scenario '1. Login to ATG' do
      atg_login_page = atg_home_page.goto_login
      atg_my_profile_page = atg_login_page.login(email, password)
    end

    scenario '2. Verify My Profile page displays' do
      expect(atg_my_profile_page.my_profile_page_exist?).to eq(true)
    end

    scenario '3. Go to App Center Catalog page' do
      atg_home_page.load
    end

    scenario "4. Click on 'Log out' link on My Account navigation" do
      atg_home_page.logout
    end

    scenario '5. Verify user logout successfully' do
      expect(atg_home_page.logout_successful?).to eq(true)
    end
  end

  context 'Log out from Check Out page' do
    scenario '1. Login to ATG' do
      atg_login_page = atg_home_page.goto_login
      atg_my_profile_page = atg_login_page.login(email, password)
    end

    scenario '2. Verify My Profile page displays' do
      expect(atg_my_profile_page.my_profile_page_exist?).to eq(true)
    end

    scenario '3. Go to Check Out page' do
      atg_checkout_page = atg_my_profile_page.goto_checkout
    end

    scenario "4. Click on 'Log out' link on My Account navigation" do
      atg_checkout_page.logout
    end

    scenario '5. Verify user logout successfully' do
      expect(atg_checkout_page.logout_successful?).to eq(true)
    end
  end
end
