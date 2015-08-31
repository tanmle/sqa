require File.expand_path('../../spec_helper', __FILE__)
require 'atg_home_page'

=begin
Verify user can search product on Catalog page by: SKU, name
=end

# initial variables
atg_home_page = HomeATG.new
atg_search_result_page = nil
product_info = nil
search_info = nil
cookie_session_id = nil

feature "TC32 - Catalog - Search for product on the Catalog page - ENV = '#{Data::ENV_CONST}' - Locale = '#{Data::LOCALE_CONST}'", js: true do
  before :all do
    cookie_session_id = atg_home_page.load
  end

  context 'Search product by Title name' do
    scenario '' do
      pending "***SESSION_ID: #{cookie_session_id}"
    end

    scenario '1. Search product by name' do
      # Get random product info
      obj_temp = atg_home_page.search_chosen_product_by('name')

      # Search product by Name
      atg_search_result_page = obj_temp[0]
      product_info = obj_temp[1]

      # Get product info on Search result page
      search_info = atg_search_result_page.get_item_infor(product_info[:id])
    end

    scenario '2. Verify search result page displays' do
      expect(atg_search_result_page.search_result_page_existed?).to eq(true)
    end

    scenario '3. Verify product displays on Search result page with correct Header' do
      expect(atg_search_result_page.result_for_title).to include(product_info[:title])
    end

    scenario '4. Verify product displays on Search result page with correct Title' do
      expect(search_info[:title]).to eq(product_info[:title])
    end

    scenario '5. Verify product displays on Search result page with correct Price' do
      if Data::LOCALE_CONST == 'US'
        expect(search_info[:price]).to eq(product_info[:price])
      end
    end

    scenario '6. Verify product displays on Search result page with correct Image' do
      expect(atg_search_result_page.item_image_existed(product_info[:id])).to include(product_info[:id].gsub('prod', ''))
    end

    # scenario "7. Verify 'Add to Cart' button product displays on Search result page" do
    # expect(atg_search_result_page.add_to_cart_button_existed?(product_info[:id])).to eq(true)
    # end
  end

  context 'Search product by Product ID' do
    scenario '1. Search product by ID' do
      # Get product information
      atg_home_page.load
      obj_temp = atg_home_page.search_chosen_product_by('id')

      # Search for product by ID
      atg_search_result_page = obj_temp[0]
      product_info = obj_temp[1]

      # Get product info on Search result page
      search_info = atg_search_result_page.get_item_infor(product_info[:id])
    end

    scenario '2. Verify search result page displays' do
      expect(atg_search_result_page.search_result_page_existed?).to eq(true)
    end

    scenario '3. Verify product displays on Search result page with proper Header' do
      expect(atg_search_result_page.result_for_title).to include(product_info[:id])
    end

    scenario '4. Verify product displays on Search result page with correct Title' do
      expect(search_info[:title]).to eq(product_info[:title])
    end

    scenario '5. Verify product displays on Search result page with correct Price' do
      if Data::LOCALE_CONST == 'US'
        expect(search_info[:price]).to eq(product_info[:price])
      end
    end

    scenario '6. Verify product displays on Search result page with correct Image' do
      expect(atg_search_result_page.item_image_existed(product_info[:id])).to include(product_info[:id].gsub('prod', ''))
    end

    # scenario "7. Verify 'Add to Cart' button product displays on Search result page" do
    # expect(atg_search_result_page.add_to_cart_button_existed?(product_info[:id])).to eq(true)
    # end
  end
end
