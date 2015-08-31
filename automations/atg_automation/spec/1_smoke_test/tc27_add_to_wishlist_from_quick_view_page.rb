require File.expand_path('../../spec_helper', __FILE__)
require 'atg_home_page'
require 'atg_login_register_page'
require 'atg_my_profile_page'
require 'atg_wishlist_page'
require 'atg_quick_view_overlay_page'

=begin
Verify user can add a Product to Wishlist from Quick View overlay
=end

# initial variables
atg_home_page = HomeATG.new
atg_wishlist_page = nil
atg_quick_view_overlay_page = QuickViewOverlayATG.new
cookie_session_id = nil

# Product info
prod_info = nil
wishlist_info = nil
color = nil

# Account information
email = Data::EMAIL_EXIST_EMPTY_CONST
password = Data::PASSWORD_CONST

feature "TC27 - Catalog - Add to Wishlist from the Quick View overlay - ENV = '#{Data::ENV_CONST}' - Locale = '#{Data::LOCALE_CONST}'", js: true do
  before :all do
    # login to account
    cookie_session_id = atg_home_page.load
    atg_login_page = atg_home_page.goto_login
    atg_my_profile_page = atg_login_page.login(email, password)

    # Delete all wishlist item if exist
    atg_wishlist_page = atg_my_profile_page.goto_my_wishlist
    atg_wishlist_page.delete_all_wishlist_items
  end

  context 'Print Session ID' do
    scenario '' do
      pending "***SESSION_ID: #{cookie_session_id}"
    end
  end

  context 'Add product to Wishlist from Quick View overlay' do
    scenario '1. Go to App Center Catalog page' do
      atg_home_page.load
      atg_home_page.see_all_result
    end

    scenario '2. Select chosen product and open Quick View' do
      prod_info = atg_home_page.quick_view_chosen_product
    end

    scenario '3. Add product to Wishlist' do
      color = atg_quick_view_overlay_page.add_to_wish_list
    end

    scenario 'Print title of chosen product' do
      pending "***TITLE: #{prod_info[:title]}"
    end

    scenario '4. Go to Wishlist page' do
      atg_wishlist_page = atg_home_page.goto_my_wishlist
    end

    scenario '5. Verify Wishlist page displays' do
      expect(atg_wishlist_page.wishlist_page_existed?).to eq(true)
    end
  end

  context 'Verify product is added to Wishlist successfully' do
    scenario '1. Get Wishlist items information' do
      info = atg_wishlist_page.get_product_info_in_wishlist
      wishlist_info = info.find { |e| e[:prod_id].include?(prod_info[:id]) }
    end

    scenario '2. Verify product is added to Wishlist correct ID' do
      expect(wishlist_info[:prod_id]).to eq(prod_info[:id])
    end

    scenario '3. Verify product is added to Wishlist correct Title' do
      color = ' - ' + color if !color.nil?
      expect(wishlist_info[:title].chomp).to(eq("#{prod_info[:cart_title].chomp}#{color}")) || expect(wishlist_info[:title]).to(eq("#{prod_info[:cart_title].chomp.gsub(/[[:digit:]]/, '')}#{color}"))
    end

    scenario "4. Verify 'Add to Cart' button exists" do
      expect(atg_wishlist_page.add_to_card_button_existed?).to eq(true)
    end

    scenario "5. Verify 'Share this wishlist' button exists" do
      expect(atg_wishlist_page.share_this_wishlist_button_existed?).to eq(true)
    end
  end

  # Delete all Wishlist items
  after :all do
    atg_wishlist_page.delete_all_wishlist_items
  end
end
