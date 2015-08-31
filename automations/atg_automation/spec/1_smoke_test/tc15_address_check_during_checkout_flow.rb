require File.expand_path('../../spec_helper', __FILE__)
require 'atg_home_page'
require 'atg_checkout_page'
require 'atg_checkout_shipping_page'

=begin
Verify user can add address information is checked while adding to account during check out
=end

# initial variables
atg_home_page = HomeATG.new
atg_checkout_page = nil
atg_shipping_page = nil
cookie_session_id = nil
email_address = Data::EMAIL_GUEST_CONST
continue_flag = false

if Data::ZIP_CONST.include?('-')
  zip_code_wo_extended = Data::ZIP_CONST[0..Data::ZIP_CONST.index('-') - 1]
else
  zip_code_wo_extended = Data::ZIP_CONST
end

feature "TC15 - Address Check during checkout flow - ENV = '#{Data::ENV_CONST}' - Locale = '#{Data::LOCALE_CONST}'", js: true do
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
  scenario '1. Add item(s) to cart then go to checkout page' do
    atg_home_page.add_random_product_to_cart
    atg_checkout_page = atg_home_page.goto_checkout
  end

  scenario '2. Enter guest email address' do
    atg_shipping_page = atg_checkout_page.checkout_asguest(email_address)
  end

  scenario '3. Enter invalid Street Address' do
    atg_shipping_page.fill_shipping_address Data::FIRSTNAME_CONST, Data::LASTNAME_CONST, 'bad_address', 'bad_city', Data::STATE_CODE_CONST, Data::ZIP_CONST, Data::PHONE_CONST, false
  end

  scenario "5. Verify - message 'Sorry, We could not find a match for your address.' displays" do
    expect(atg_shipping_page.validate_address_form.address_error_message_txt.text).to eq('Sorry, We could not find a match for your address.')
    atg_shipping_page.close_validate_address_and_refresh_page
  end

  scenario '6. Enter invalid zip code for US, invalid address for CA (enough to site list addresses for choosing)' do
    atg_shipping_page.fill_shipping_address Data::FIRSTNAME_CONST, Data::LASTNAME_CONST, "11#{Data::ADDRESS1_CONST}", Data::CITY_CONST, Data::STATE_CODE_CONST, zip_code_wo_extended, Data::PHONE_CONST, false
  end

  scenario "7. Verify - message 'Sorry, we don't recognize your house or building number...' displays" do
    expect(atg_shipping_page.validate_address_form.address_error_message_txt.text).to eq("Sorry, we don't recognize your house or building number. To proceed, please check and chose from one of the options below.")
  end

  scenario '8. Choose an address from list' do
    expect(atg_shipping_page.has_suggested_range_address?).to eq(true)
    continue_flag = true if atg_shipping_page.choose_an_address
  end

  scenario "9. Verify 'Verify your address details' popup disappears" do
    expect(atg_shipping_page.validate_address_popup_not_appear?).to eq(true) if continue_flag
  end

  scenario '10. Click on Continue button' do
    atg_shipping_page.shipping_address_form.continue_btn.click if continue_flag
  end

  scenario '11. Verify address is suggested successful' do
    expect(atg_shipping_page.validate_address_popup_not_appear?).to eq(true) if continue_flag
  end
end
