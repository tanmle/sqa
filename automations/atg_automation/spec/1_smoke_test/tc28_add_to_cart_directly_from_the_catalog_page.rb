require File.expand_path('../../spec_helper', __FILE__)
require 'atg_home_page'
require 'atg_login_register_page'
require 'atg_my_profile_page'
require 'atg_checkout_page'

=begin
Verify user can add a Product to Cart from Catalog page
=end

# initial variables
atg_home_page = HomeATG.new
atg_check_out_page = nil
cookie_session_id = nil

# Product info
prod_info = nil
cart_info = nil

# Account information
email = Data::EMAIL_EXIST_EMPTY_CONST
password = Data::PASSWORD_CONST

feature "TC28 - Catalog - Add to Cart directly from the Catalog page - ENV = '#{Data::ENV_CONST}' - Locale = '#{Data::LOCALE_CONST}'", js: true do
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

  context 'Add a product to Cart from the Catalog page' do
    scenario '1. Go to App Center Catalog page' do
      atg_home_page.load
      atg_home_page.see_all_result
      prod_info = atg_home_page.get_chosen_product_info
    end

    scenario '2. Add chosen product to Cart' do
      atg_home_page.add_product_to_cart_from_catalog(prod_info[:id])
    end

    scenario 'Print title of chosen product' do
      pending "***TITLE: #{prod_info[:title]}"
    end

    scenario '3. Go to Cart page' do
      # Go to Product Cart page
      atg_check_out_page = atg_home_page.goto_checkout

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
      color = ' - ' + color if !color.nil?
      expect(cart_info[:title].chomp).to(eq("#{prod_info[:cart_title].chomp}#{color}")) || expect(cart_info[:title].chomp).to(eq("#{prod_info[:cart_title].chomp.gsub(/[[:digit:]]/, '')}#{color}"))
    end
  end

  # Delete all items in Cart
  after :all do
    atg_check_out_page.remove_all_items_in_shop_cart
  end
end
