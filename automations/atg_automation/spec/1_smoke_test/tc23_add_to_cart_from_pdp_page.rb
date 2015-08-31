require File.expand_path('../../spec_helper', __FILE__)
require 'atg_home_page'
require 'atg_login_register_page'
require 'atg_my_profile_page'
require 'atg_product_detail_page'
require 'atg_checkout_page'

=begin
Verify user can add product to Cart from PDP page successfully
=end

# initial variables
atg_home_page = HomeATG.new
atg_my_profile_page = nil
atg_product_detail_page = nil
atg_check_out_page = nil
prod_info = nil
cart_info = nil
color = nil
cookie_session_id = nil

# Account information
email = Data::EMAIL_EXIST_EMPTY_CONST
password = Data::PASSWORD_CONST

feature "TC23 - Catalog - Add to Cart from PDP Page - ENV = '#{Data::ENV_CONST}' - Locale = '#{Data::LOCALE_CONST}'", js: true do
  before :all do
    # Go to App Center page
    cookie_session_id = atg_home_page.load

    # Login to account
    atg_login_page = atg_home_page.goto_login
    atg_my_profile_page = atg_login_page.login(email, password)

    # Delete all products in Cart
    atg_my_profile_page.remove_all_items_in_shop_cart
  end

  context 'Print Session ID' do
    scenario '' do
      pending "***SESSION_ID: #{cookie_session_id}"
    end
  end

  context 'Add product to Cart from PDP Page' do
    scenario '1. Go to App Center Catalog page' do
      atg_home_page.load
      atg_home_page.see_all_result
    end

    scenario '2. Select chosen product and open PDP page' do
      # obj_temp = atg_home_page.click_random_product('link')
      obj_temp = atg_home_page.click_chosen_product('link')
      atg_product_detail_page = obj_temp[0]
      prod_info = obj_temp[1]
    end

    scenario '3. Make sure that Add to Cart button is on PDP page' do
      expect(atg_product_detail_page.add_to_cart_button_existed?).to eq(true)
    end

    scenario 'Print title of chosen product' do
      pending "***TITLE: #{prod_info[:title]}"
    end

    scenario '4. Click on Add to Cart button on PDP page' do
      color = atg_product_detail_page.add_to_cart_from_pdp
    end

    scenario '5. Go to Cart page' do
      # Go to Product Cart page
      atg_check_out_page = atg_my_profile_page.goto_checkout

      # Get product info on Cart page
      info = atg_check_out_page.get_items_info_in_cart
      cart_info = info.find { |e| e[:prod_id].include?(prod_info[:id]) }
    end
  end

  context 'Verify product is added to Cart successfully' do
    scenario '1. Verify that product is added to Cart with correct ID' do
      expect(cart_info[:prod_id]).to eq(prod_info[:id])
    end

    scenario '2. Verify that product is added to Cart with correct Title' do
      expect(cart_info[:title]).to eq("#{prod_info[:cart_title].chomp}#{color}")
    end
  end

  after :all do
    atg_check_out_page.remove_all_items_in_shop_cart
  end
end
