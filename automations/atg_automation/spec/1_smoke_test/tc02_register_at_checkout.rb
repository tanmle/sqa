require File.expand_path('../../spec_helper', __FILE__)
require 'atg_home_page'
require 'atg_checkout_page'
require 'atg_checkout_shipping_page'
require 'atg_checkout_payment_page'
require 'atg_checkout_review_page'
require 'atg_checkout_confirmation_page'
require 'atg_my_profile_page'

=begin
Verify that user can register a new account at Confirmation page while checking out successfully
=end

# initial variables
atg_home_page = HomeATG.new
atg_checkout_page = nil
atg_my_profile_page = nil
atg_checkout_shipping_page = nil
atg_checkout_payment_page = nil
atg_checkout_review_page = nil
atg_checkout_confirmation = nil
cookie_session_id = nil

# Account info
email_guest = Data::EMAIL_GUEST_CONST
registered_account_info = "#{Data::FIRSTNAME_CONST} #{Data::LASTNAME_CONST} #{email_guest} #{Data::COUNTRY_CONST}"

feature "TC02 - Account Management - Register account during check out - ENV = '#{Data::ENV_CONST}' - Locale = '#{Data::LOCALE_CONST}'", js: true do
  before :all do
    cookie_session_id = atg_home_page.load
  end

  context 'Print Session ID' do
    scenario '' do
      pending "***SESSION_ID: #{cookie_session_id}"
    end
  end

  context 'On Home page' do
    scenario '1. Add to cart' do
      search_item = atg_home_page.get_random_product_id
      atg_home_page.add_to_cart search_item
    end

    scenario '2. Go to Check out page' do
      atg_checkout_page = atg_home_page.goto_checkout
    end
  end

  context 'On Check Out page' do
    scenario '1. Enter guest email into check out as guest' do
      atg_checkout_shipping_page = atg_checkout_page.checkout_asguest email_guest
    end

    scenario '2. Fill out shipping address form' do
      atg_checkout_payment_page = atg_checkout_shipping_page.fill_shipping_address(
        Data::FIRSTNAME_CONST,
        Data::LASTNAME_CONST,
        Data::ADDRESS1_CONST,
        Data::CITY_CONST,
        Data::STATE_CODE_CONST,
        Data::ZIP_CONST,
        Data::PHONE_CONST
      )
    end

    scenario '3. Payment with credit card' do
      atg_checkout_review_page = atg_checkout_payment_page.add_credit_card(
        card_number: Data::CARD_NUMBER_CONST,
        card_name: Data::NAME_ON_CARD_CONST,
        exp_month: Data::EXP_MONTH_NAME_CONST,
        exp_year: Data::EXP_YEAR_CONST,
        security_code: Data::SECURITY_CODE_CONST
      )
    end

    scenario '4. Place order' do
      atg_checkout_confirmation = atg_checkout_review_page.place_order
    end

    scenario '5. Verify Opt-in was checked by Default (US site) - Unchecked by default (CA site)' do
      fail atg_checkout_confirmation if atg_checkout_confirmation.class == String
      if atg_checkout_confirmation.current_url.include? 'en-us'
        expect(atg_checkout_confirmation.confirmation_new_account_opt_in_checked?).to eq(true)
      else
        expect(atg_checkout_confirmation.confirmation_new_account_opt_in_checked?).to eq(false)
      end
    end

    scenario '6. Create account from confirmation page' do
      atg_checkout_confirmation.create_account(
        Data::FIRSTNAME_CONST,
        Data::LASTNAME_CONST,
        Data::PASSWORD_CONST,
        Data::PASSWORD_CONST
      )
    end

    scenario '7.  Verify account created successfully popup is displayed' do
      expect(atg_checkout_confirmation.account_created_successfully_displayed?).to eq(true)
    end

    scenario '8. Goto My profile page' do
      atg_my_profile_page = atg_checkout_confirmation.goto_my_account
    end
  end

  context 'On My profile page' do
    scenario '1. Click on Account information link' do
      atg_my_profile_page.goto_account_information
    end

    scenario "2. Account information in My Profile page is correct - #{email_guest}" do
      expect(atg_my_profile_page.get_account_info).to eq(registered_account_info)
    end
  end
end
