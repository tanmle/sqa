require File.expand_path('../../spec_helper', __FILE__)
require 'atg_home_page'
require 'atg_login_register_page'
require 'atg_my_profile_page'

=begin
Verify that user can log-in to an existing account successfully
=end

# initial variables
atg_home_page = HomeATG.new
atg_login_page = nil
atg_my_profile_page = nil
cookie_session_id = nil

# Account info
email = Data::EMAIL_EXIST_EMPTY_CONST
password = Data::PASSWORD_CONST
account_info = "#{Data::FIRSTNAME_CONST} #{Data::LASTNAME_CONST} #{email} #{Data::COUNTRY_CONST}"

feature "TC06 - Account Management - Login - ENV = '#{Data::ENV_CONST}' - Locale = '#{Data::LOCALE_CONST}'", js: true do
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

  context 'On Login page' do
    scenario "1. Login with an existing Email (#{email})" do
      atg_my_profile_page = atg_login_page.login(email, password)
    end

    scenario '2. Verify My Profile page displays' do
      expect(atg_my_profile_page.my_profile_page_exist?).to eq(true)
    end
  end

  context 'On My Profile page' do
    scenario '1. Click on Account Information link' do
      atg_my_profile_page.goto_account_information
    end

    scenario '2. Verify account information displays correctly' do
      expect(atg_my_profile_page.get_account_info).to eq(account_info)
    end
  end

  # Log out
  after :all do
    atg_my_profile_page.logout
  end
end
