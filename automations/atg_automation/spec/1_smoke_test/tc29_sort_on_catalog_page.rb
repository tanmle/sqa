require File.expand_path('../../spec_helper', __FILE__)
require 'atg_home_page'

=begin
Verify user can sort apps on Catalog page with all sort options: high -> low, low -> high, alphabetical
=end

# initial variables
atg_home_page = HomeATG.new
cookie_session_id = nil

feature "TC29 - Catalog - Sort on Catalog Page - ENV = '#{Data::ENV_CONST}' - Locale = '#{Data::LOCALE_CONST}'", js: true do
  # before section: pre-conditions
  before :all do
    cookie_session_id = atg_home_page.load
  end

  context 'Print Session ID' do
    scenario '' do
      pending "***SESSION_ID: #{cookie_session_id}"
    end
  end

  # steps, verify points section
  context 'Sort price by high -> low' do
    # scenario '1. Click on see all result' do
    #  atg_home_page.see_all_result
    # end

    scenario '1. Sort price by high -> low' do
      atg_home_page.sort_result_by(SortOption::HIGH_TO_LOW_CONST)
    end

    scenario '2. Verify sort function work correctly' do
      expect(atg_home_page.price_sorted_high_to_low?).to eq(true)
    end
  end

  context 'Sort price by low -> high' do
    scenario '1. Sort price by low -> high' do
      atg_home_page.sort_result_by(SortOption::LOW_TO_HIGH_CONST)
    end

    scenario '2. Verify sort function work correctly' do
      expect(atg_home_page.price_sorted_low_to_high?).to eq(true)
    end
  end

  context 'Sort title alphabetical (A->Z)' do
    scenario '1. Sort by alphabetical(A->Z)' do
      atg_home_page.sort_result_by(SortOption::ALPHABETICAL_CONST)
    end

    scenario '2. Verify sort function work correctly' do
      expect(atg_home_page.title_sorted_alphabetical?).to eq(true)
    end
  end
end
