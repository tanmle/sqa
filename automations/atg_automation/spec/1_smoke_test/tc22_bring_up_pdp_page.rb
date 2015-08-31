require File.expand_path('../../spec_helper', __FILE__)
require 'atg_home_page'

=begin
Verify user can view product detail page (PDP) from Catalog page
=end

# initial variables
atg_home_page = HomeATG.new
atg_product_details_page = nil
product_info = nil
cookie_session_id = nil

feature "TC22 - Catalog - View PDP - ENV = '#{Data::ENV_CONST}' - Locale = '#{Data::LOCALE_CONST}'", js: true do
  before :all do
    # load catalog page
    cookie_session_id = atg_home_page.load
  end

  context 'Print Session ID' do
    scenario '' do
      pending "***SESSION_ID: #{cookie_session_id}"
    end
  end

  context 'On catalog page' do
    scenario '1. Click on any product image or title' do
      obj_temp = atg_home_page.click_random_product('link')
      atg_product_details_page = obj_temp[0]
      product_info = obj_temp[1]
    end

    scenario '2. Verify PDP page is displayed' do
      expect(atg_product_details_page.product_pdp_page_displays?(product_info[:id])).to eq(true)
    end
  end

  context 'On product pdp page' do
    scenario '1. Verify breadcrumbs contains product name' do
      expect(atg_product_details_page.get_breadcrumbs_text).to include(product_info[:title])
    end

    scenario '2. Verify image of product is displayed on pdp page' do
      expect(atg_product_details_page.get_image_link).to eq(product_info[:image].gsub('prod-cat', 'prod-lg'))
    end

    scenario '3. Verify price is same on product page' do
      expect(atg_product_details_page.get_product_price).to include(product_info[:price])
    end

    scenario '4. Verify add to cart buttons exists on pdp product page' do
      expect(atg_product_details_page.add_to_cart_button_existed?).to eq(true)
    end

    scenario '5. Verify Wishlist button exists on pdp product page' do
      expect(atg_product_details_page.wish_list_link_existed?).to eq(true)
    end

    scenario '6. Verify sub navigation bar is existed on pdp product page' do
      expect(atg_product_details_page.sub_navigation_bar_existed?).to eq(true)
    end

    scenario '7. Verify Buy Now button on sub navigation bar displays when scrolling down' do
      expect(atg_product_details_page.buy_now_button_displays_on_sub_navigation?).to eq(true)
    end
  end
end
