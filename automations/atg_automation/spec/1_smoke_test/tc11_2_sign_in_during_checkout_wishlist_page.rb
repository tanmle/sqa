require File.expand_path('../../spec_helper', __FILE__)
require 'atg_home_page'
require 'atg_login_register_page'
require 'atg_my_profile_page'
require 'atg_wishlist_page'
require 'atg_quick_view_overlay_page'
require 'atg_checkout_page'
require 'atg_checkout_shipping_page'
require 'atg_checkout_payment_page'
require 'atg_checkout_review_page'
require 'atg_checkout_confirmation_page'

=begin
Verify that user can add to card from Wishlist page and Complete checkout
=end

# initial variables
atg_home_page = HomeATG.new
atg_wishlist_page = nil
atg_check_out_page = nil
atg_shipping_page = nil
atg_payment_page = nil
atg_review_page = nil
atg_confirmation_page = nil
atg_quick_view_overlay_page = QuickViewOverlayATG.new
cookie_session_id = nil

feature "TC11.2 - Check out - Sign in during checkout flow and item is added from Wishlist page - ENV = '#{Data::ENV_CONST}' - Locale = '#{Data::LOCALE_CONST}'", js: true do
  # before section: pre-conditions
  before :all do
    # Login to account
    cookie_session_id = atg_home_page.load
    atg_login_page = atg_home_page.goto_login
    atg_my_profile_page = atg_login_page.login(Data::EMAIL_EXIST_FULL_CONST, Data::PASSWORD_CONST)

    # Empty Wishlist
    atg_wishlist_page = atg_my_profile_page.goto_my_wishlist
    atg_wishlist_page.delete_all_wishlist_items
    atg_wishlist_page.remove_all_items_in_shop_cart

    # load catalog page
    atg_home_page.load
  end

  context 'Print Session ID' do
    scenario '' do
      pending "***SESSION_ID: #{cookie_session_id}"
    end
  end

  # steps, verify points section
  context 'Add to Cart from Wishlist page' do
    scenario '1. Quick view an item' do
      atg_home_page.quick_view_random_product
    end

    scenario '2. Add item to wishlist' do
      atg_quick_view_overlay_page.add_to_wish_list
    end

    scenario '3. Go to wishlist page' do
      atg_home_page.goto_my_wishlist
    end

    scenario '4. Add to card' do
      atg_wishlist_page.add_to_cart
    end

    scenario '5. Verify item is removed from My Wishlist' do
      expect(atg_wishlist_page.wishlist_form.text).to include('Your LeapFrog Wishlist is empty.')
    end
  end

  context 'Complete checkout - record transaction' do
    before :all do
      atg_check_out_page = atg_wishlist_page.goto_checkout
    end

    scenario '1. Go to Shipping page' do
      atg_shipping_page = atg_check_out_page.check_out_as_logged_in_account
    end

    scenario '2. Go to Payment page' do
      atg_payment_page = atg_shipping_page.shipping_as_full_information_account
    end

    scenario '3. Go to Review page' do
      atg_review_page = atg_payment_page.pay_as_full_information_account
    end

    scenario '4. Go to Confirmation page' do
      atg_confirmation_page = atg_review_page.place_order
    end

    scenario '5. Verify transaction ID displays' do
      expect(atg_confirmation_page.id_transaction_displayed?).to eq(true)
    end
  end
end
