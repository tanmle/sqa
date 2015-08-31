require File.expand_path('../../spec_helper', __FILE__)
require 'atg_home_page'
require 'atg_login_register_page'
require 'atg_my_profile_page'
require 'atg_wishlist_page'

=begin
Verify user can add product to Wish list as Guest
=end

# initial variables
atg_home_page = HomeATG.new
atg_login_page = nil
atg_my_profile_page = nil
atg_product_detail_page = nil
atg_wishlist_page = nil
cookie_session_id = nil

# Product info
prod_info = nil
wishlist_info = nil
color = nil

# Account information
email_guest = Data::EMAIL_GUEST_CONST
email = Data::EMAIL_EXIST_EMPTY_CONST
password = Data::PASSWORD_CONST
first_name = Data::FIRSTNAME_CONST
last_name = Data::LASTNAME_CONST

feature "TC31 - Catalog - Add to Wishlist as Guest - ENV = '#{Data::ENV_CONST}' - Locale = '#{Data::LOCALE_CONST}'", js: true do
  before :all do
    # Login page
    cookie_session_id = atg_home_page.load
    atg_login_page = atg_home_page.goto_login
    atg_my_profile_page = atg_login_page.login(email, password)

    # Delete all wishlist items
    atg_wishlist_page = atg_my_profile_page.goto_my_wishlist
    atg_wishlist_page.delete_all_wishlist_items

    # Log out
    atg_wishlist_page.logout

    # Load catalog page
    atg_home_page.load
    atg_home_page.see_all_result
  end

  context 'Print Session ID' do
    scenario '' do
      pending "***SESSION_ID: #{cookie_session_id}"
    end
  end

  # steps, verify points section
  context 'Add to Wishlist as guest - Log in to existing account' do
    context 'Go to PDP page' do
      scenario '1. Select chosen product and open PDP page' do
        obj_temp = atg_home_page.click_chosen_product('link')
        atg_product_detail_page = obj_temp[0]
        prod_info = obj_temp[1]
      end

      scenario 'Print title of chosen product' do
        pending "***TITLE: #{prod_info[:title]}"
      end

      scenario '2. Verify PDP page displays' do
        expect(atg_product_detail_page.product_pdp_page_displays?(prod_info[:id])).to eq(true)
      end
    end

    context 'Add product to Wishlist page' do
      scenario '1. Click on Add to Wishlist button' do
        color = atg_product_detail_page.add_to_wishlist
      end

      scenario '2. Verify login page is displayed and user can login' do
        atg_login_page.login(email, password)
      end

      scenario '3. Go to Wishlist page' do
        atg_wishlist_page = atg_product_detail_page.goto_my_wishlist
      end

      scenario '4. Verify Wishlist page displays' do
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
        expect(wishlist_info[:title]).to eq("#{prod_info[:cart_title]}#{color}")
      end

      scenario "4. Verify 'Add to Cart' button exists" do
        expect(atg_wishlist_page.add_to_card_button_existed?).to eq(true)
      end

      scenario "5. Verify 'Share this wishlist' exists" do
        expect(atg_wishlist_page.share_this_wishlist_button_existed?).to eq(true)
      end
    end

    # Delete all wishlist items and log out
    after :all do
      atg_wishlist_page.delete_all_wishlist_items
      atg_wishlist_page.logout
    end
  end

  context 'Add to Wishlist as guest - Create new account' do
    before :all do
      atg_home_page.load
      atg_home_page.see_all_result
    end

    context 'Go to PDP page' do
      scenario '1. Select chosen product and open PDP page' do
        obj_temp = atg_home_page.click_chosen_product('link')
        atg_product_detail_page = obj_temp[0]
        prod_info = obj_temp[1]
      end

      scenario 'Print title of chosen product' do
        pending "***TITLE: #{prod_info[:title]}"
      end

      scenario '2. Verify PDP page displays' do
        expect(atg_product_detail_page.product_pdp_page_displays?(prod_info[:id])).to eq(true)
      end
    end

    context 'Add product to Wishlist page' do
      scenario '1. Click on Add to Wishlist button' do
        color = atg_product_detail_page.add_to_wishlist
      end

      scenario '2. Verify register/login page is displayed and user can sign up' do
        atg_login_page.register(first_name, last_name, email_guest, password, password)
      end

      scenario '3. Go to Wishlist page' do
        atg_wishlist_page = atg_product_detail_page.goto_my_wishlist
      end

      scenario '4. Verify Wishlist page displays' do
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
        expect(wishlist_info[:title]).to eq("#{prod_info[:cart_title]}#{color}")
      end

      scenario "4. Verify 'Add to Cart' button exists" do
        expect(atg_wishlist_page.add_to_card_button_existed?).to eq(true)
      end

      scenario "5. Verify 'Share this wishlist' exists" do
        expect(atg_wishlist_page.share_this_wishlist_button_existed?).to eq(true)
      end
    end

    # Delete all wishlist items and log out
    after :all do
      atg_wishlist_page.delete_all_wishlist_items
      atg_wishlist_page.logout
    end
  end
end
