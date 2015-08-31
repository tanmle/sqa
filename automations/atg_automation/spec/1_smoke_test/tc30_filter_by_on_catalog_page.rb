require File.expand_path('../../spec_helper', __FILE__)
require 'atg_home_page'

=begin
Verify user can fill apps on Catalog page by: product, age, type,...
=end

# initial variables
atg_home_page = HomeATG.new
filter_info = nil
filter_info1 = nil
filter_info2 = nil
cookie_session_id = nil

feature "TC30 - Catalog - Verify User can apply filters to results on the catalog page - ENV = '#{Data::ENV_CONST}' - Locale = '#{Data::LOCALE_CONST}'", js: true do
  before :all do
    cookie_session_id = atg_home_page.load
  end

  context 'Print Session ID' do
    scenario '' do
      pending "***SESSION_ID: #{cookie_session_id}"
    end
  end

  # steps, verify points section
  context 'Single filter by product' do
    # before section: pre-conditions
    before :all do
      atg_home_page.load
    end

    scenario '1. Filter LeapTV' do
      filter_info = atg_home_page.filter_chosen_product
    end

    scenario '2. Verify breadcrumb displays correctly' do
      expect(atg_home_page.get_text_breadcrumb).to include(filter_info[:title])
    end

    # scenario '3. Click see all all results' do
    # atg_home_page.see_all_result
    # end

    # scenario '4. Verify number of item is mapped between filter option and real items have shown' do
    # expect(atg_home_page.get_all_product_info.count).to eq(filter_info[:count])
    # end

    scenario '3. Verify filter works correctly' do
      expect(atg_home_page.products_filter_correct?(filter_info[:title])).to eq(true)
    end
  end

  context 'Single filter by age' do
    # before section: pre-conditions
    before :all do
      atg_home_page.load
    end

    scenario '1. Filter age = 1' do
      filter_info = atg_home_page.filter_chosen_age
    end

    scenario '2. Verify breadcrumb displays correctly' do
      expect(atg_home_page.get_text_breadcrumb).to include(filter_info[:title][0])
    end

    # scenario '3. Click see all all results' do
    # atg_home_page.see_all_result
    # end

    # scenario '4. Verify number of item is maped between filter option and real items have shown' do
    # expect(atg_home_page.get_all_product_info.count).to eq(filter_info[:count])
    # end

    scenario '3. Verify filter works correctly' do
      expect(atg_home_page.age_filter_correct?(filter_info[:title])).to eq(true)
    end
  end

  #
  # With multi filter, verify point here is:
  #   - Breadcrumbs
  #   - Count of items
  #   - Those items
  #
  context 'Multi filter by type' do
    # before section: pre-conditions
    before :all do
      atg_home_page.load
    end

    scenario '1. Filter the 1st type = DVD' do
      filter_info1 = atg_home_page.filter_first_option
    end

    scenario '2. Filter the 2nd type = toy' do
      filter_info2 = atg_home_page.filter_second_option
    end

    scenario '3. Verify breadcrumb displays 1st filter' do
      expect(atg_home_page.get_text_breadcrumb).to include(filter_info1[:title])
    end

    scenario '4. Verify breadcrumb displays 2nd filter' do
      expect(atg_home_page.get_text_breadcrumb).to include(filter_info2[:title])
    end

    scenario '5. Click see all all results' do
      atg_home_page.see_all_result
    end

    scenario '6. Verify number of item is maped between filter option and real items have shown' do
      expect(atg_home_page.get_all_product_info.count).to eq(filter_info1[:count] + filter_info2[:count])
    end
  end
end
