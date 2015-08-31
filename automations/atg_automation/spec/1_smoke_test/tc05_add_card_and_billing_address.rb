require File.expand_path('../../spec_helper', __FILE__)
require 'atg_home_page'
require 'atg_login_register_page'
require 'atg_my_profile_page'

=begin
Verify that user can add the Billing method and Billing address into account successfully
=end

# initial variables
atg_home_page = HomeATG.new
atg_my_profile_page = nil
cookie_session_id = nil

feature "TC05 - Account Management - Add Billing Method and Billing Address - ENV = '#{Data::ENV_CONST}' - Locale = '#{Data::LOCALE_CONST}'", js: true do
  before :all do
    cookie_session_id = atg_home_page.load
    atg_login_page = atg_home_page.goto_login
    atg_my_profile_page = atg_login_page.login(Data::EMAIL_EXIST_EMPTY_CONST, Data::PASSWORD_CONST)
    atg_my_profile_page.goto_account_information
    atg_my_profile_page.delete_all_addresses
    atg_my_profile_page.delete_all_payments
  end

  context 'Print Session ID' do
    scenario '' do
      pending "***SESSION_ID: #{cookie_session_id}"
    end
  end

  context 'On My Profile page' do
    scenario '1. Add new Billing Method and Billing Address' do
      credit_card = {
        card_number: Data::CARD_NUMBER_CONST,
        cart_type: Data::CARD_TYPE_CONST,
        name_on_card: Data::NAME_ON_CARD_CONST,
        exp_month: Data::EXP_MONTH_NAME_CONST,
        exp_year: Data::EXP_YEAR_CONST,
        security_code: Data::SECURITY_CODE_CONST
      }

      billing_address = {
        street_address: Data::ADDRESS1_CONST,
        city: Data::CITY_CONST,
        state: Data::STATE_CODE_CONST,
        country: Data::COUNTRY_CONST,
        postal_code: Data::ZIP_CONST,
        phone_number: Data::PHONE_CONST
      }

      atg_my_profile_page.add_new_credit_card_with_new_billing(credit_card, billing_address)
    end

    scenario '2. Verify billing address information' do
      expect(atg_my_profile_page.get_address_info).to eq(Data::BILLING_ADDRESS_INFO_CONST)
    end

    scenario '3. Verify payments information' do
      expect(atg_my_profile_page.get_payment_info).to eq(Data::PAYMENTED_INFO_CONST)
    end
  end

  after :all do
    atg_my_profile_page.delete_all_addresses
    atg_my_profile_page.delete_all_payments
  end
end
