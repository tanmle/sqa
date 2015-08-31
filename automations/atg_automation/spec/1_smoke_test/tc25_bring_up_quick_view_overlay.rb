require File.expand_path('../../spec_helper', __FILE__)
require 'atg_home_page'
require 'atg_login_register_page'
require 'atg_quick_view_overlay_page'

=begin
Verify user can bring up Quick View overlay from Catalog page successfully
=end

# initial variables
atg_home_page = HomeATG.new
atg_quick_view_overlay_page = QuickViewOverlayATG.new
cookie_session_id = nil
product_infor = nil

feature "TC25 - Catalog - Bring Up Quick View Overlay - ENV = '#{Data::ENV_CONST}' - Locale = '#{Data::LOCALE_CONST}'", js: true do
  before :all do
    cookie_session_id = atg_home_page.load
    atg_login_page = atg_home_page.goto_login
    atg_login_page.login(Data::EMAIL_EXIST_EMPTY_CONST, Data::PASSWORD_CONST)
    atg_home_page.load
  end

  context 'Print Session ID' do
    scenario '' do
      pending "***SESSION_ID: #{cookie_session_id}"
    end
  end

  context 'Bring Up Quick View Overlay' do
    scenario '1. Quick view an item' do
      product_infor = atg_home_page.quick_view_random_product
    end

    scenario '2. Verify Quick view overlay is displayed' do
      expect(atg_quick_view_overlay_page.quick_view_overlay_displayed?).to eq(true)
    end
  end

  context 'Verify information on Quick View Overlay popup' do
    scenario '1. Title of product' do
      expect(atg_quick_view_overlay_page.get_title_of_item).to eq(product_infor[:title])
    end

    scenario '2. Price of product' do
      expect(atg_quick_view_overlay_page.get_item_price).to include(product_infor[:price])
    end

    scenario '3. Link of image of product' do
      expect(atg_quick_view_overlay_page.get_image_src).to include(product_infor[:id][4..-1])
    end

    scenario "4. Verify 'Add to cart' button" do
      expect(atg_quick_view_overlay_page.add_to_cart_button_existed?).to eq(true)
    end

    scenario "5. Verify 'Add to wish list' link" do
      expect(atg_quick_view_overlay_page.add_to_wish_list_link_existed?).to eq(true)
    end

    scenario '6. Verify Quantity label' do
      expect(atg_quick_view_overlay_page.quantity_label_existed?).to eq(true)
    end

    scenario "7. Verify 'Close' button" do
      expect(atg_quick_view_overlay_page.close_button_existed?).to eq(true)
    end

    scenario '8. Click on close button' do
      atg_quick_view_overlay_page.click_close_button
    end

    scenario '9. Verify Quick View overlay disappear' do
      expect(atg_quick_view_overlay_page.quick_view_overlay_not_displayed?).to eq(true)
    end
  end
end
