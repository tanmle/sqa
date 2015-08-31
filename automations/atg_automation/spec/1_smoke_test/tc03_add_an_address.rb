require File.expand_path('../../spec_helper', __FILE__)
require 'atg_home_page'
require 'atg_login_register_page'
require 'atg_my_profile_page'

=begin
Verify that user can add an address into account at Account Management page
=end

# initial variables
atg_home_page = HomeATG.new
atg_my_profile_page = nil
cookie_session_id = nil

feature "TC03 - Account Management - Add address - ENV = '#{Data::ENV_CONST}' - Locale = '#{Data::LOCALE_CONST}'", js: true do
  before :all do
    cookie_session_id = atg_home_page.load
    atg_login_page = atg_home_page.goto_login
    atg_my_profile_page = atg_login_page.login(Data::EMAIL_EXIST_EMPTY_CONST, Data::PASSWORD_CONST)
  end

  context 'Print Session ID' do
    scenario '' do
      pending "***SESSION_ID: #{cookie_session_id}"
    end
  end

  context 'On My Profile page' do
    scenario '1. From the header click My Account > My Account' do
      atg_my_profile_page.goto_account_information
    end

    scenario '2. Verify My Profile page should be displayed' do
      expect(atg_my_profile_page.my_profile_page_exist?).to eq(true)
    end

    scenario '3. Add new address information' do
      atg_my_profile_page.add_new_address(
        first_name: Data::FIRSTNAME_CONST,
        last_name: Data::LASTNAME_CONST,
        street: Data::ADDRESS1_CONST,
        city: Data::CITY_CONST,
        state: Data::STATE_CODE_CONST,
        postal: Data::ZIP_CONST,
        phone_number: Data::PHONE_CONST
      )
    end

    scenario '4. Verify address information' do
      expect(atg_my_profile_page.get_address_info).to eq(Data::ADDRESS_INFO_CONST)
    end
  end

  after :all do
    atg_my_profile_page.delete_all_addresses
  end
end
