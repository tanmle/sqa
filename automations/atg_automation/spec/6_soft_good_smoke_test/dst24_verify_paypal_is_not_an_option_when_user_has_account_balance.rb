require File.expand_path('../../spec_helper', __FILE__)

=begin
  Verify Paypal is not an option when user has account balance
=end

env = Data::ENV_CONST.upcase
if env != 'PREVIEW' && env != 'PROD'
  require 'atg_home_page'
  require 'atg_app_center_page'
  require 'atg_login_register_page'

  # initial variables
  HomeATG.set_url URL::ATG_APP_CENTER_URL
  atg_home_page = HomeATG.new
  atg_app_center_page = AppCenterCatalogATG.new
  atg_checkout_page = nil

  # Account information
  email = Data::EMAIL_GUEST_CONST
  password = Data::PASSWORD_CONST
  locale = Data::LOCALE_CONST
  env_pin = (Data::ENV_CONST.upcase == 'PROD') ? 'PROD' : 'QA'
  account_balance = nil
  atg_checkout_payment_page = nil

  # Web Service info
  caller_id = ServicesInfo::CONST_CALLER_ID

  feature "DST24 - Verify Paypal is not an option when user has account balance - ENV = '#{Data::ENV_CONST}' - Locale = '#{Data::LOCALE_CONST}'", js: true do
    next unless pin_available?(Data::ENV_CONST, Data::LOCALE_CONST)

    status_code = '200'

    check_status_url_and_print_session atg_home_page, status_code

    context 'Precondition create account, link to all device and redeem code' do
      context 'Create new account and link to all device' do
        create_account_and_link_all_devices(Data::FIRSTNAME_CONST, Data::LASTNAME_CONST, email, password, password)
      end

      context 'Redeem Value Card to Account' do
        pin_info = pin_info1 = nil
        it 'Redeem Value Card' do
          # Get PIN value from DB
          pin_info = PinRedemption.get_pin_info(env_pin, 'USV1', 'Available')
          pin = pin_info['pin_number'].delete '-'

          search_res = CustomerManagement.search_for_customer(caller_id, email)
          cus_id = search_res.xpath('//customer/@id').text

          PinManagementService.redeem_value_card(caller_id, cus_id, pin, locale)
          pin_info1 = PinManagementService.get_pin_information(caller_id, pin)

          pending "***Redeem Value Card: #{pin_info['pin_number']}"
        end

        it 'Verify pin status is REDEEMED' do
          expect(pin_info1[:status]).to eq('REDEEMED')
        end

        it 'Update PIN status to Used' do
          PinRedemption.update_pin_status(env_pin, 'USV1', pin_info['pin_number'], 'Used') if pin_info1[:status] == 'REDEEMED'
        end
      end
    end

    context 'Add to Cart from the App Center Catalog Page' do
      scenario '1. Go to App Center home page' do
        atg_home_page.load
        pending("***1. Go to App Center home page #{atg_home_page.current_url}")
      end

      scenario '2. Add app to Cart' do
        atg_app_center_page.show_all_dropdowns
        account_balance = atg_app_center_page.account_balance
        product_id = atg_app_center_page.get_random_pro_greater_acc_balance(account_balance.delete('$').to_f)
        atg_app_center_page.add_to_cart_from_catalog product_id[:prod_id]
      end

      scenario '3. Go to App Center check out page' do
        atg_checkout_page = atg_app_center_page.sg_go_to_check_out
        pending("***3. Go to App Center check out page #{atg_checkout_page.current_url}")
      end
    end

    context 'Verify PayPal button does not display on Payment page' do
      scenario '1. Go to Payment page' do
        atg_checkout_payment_page = atg_checkout_page.sg_go_to_payment
        pending("***1. Go to Payment page #{atg_checkout_payment_page.current_url}")
      end

      scenario "2. Verify the Account Balance amount is #{account_balance}" do
        acc_balance_in_payment = atg_checkout_payment_page.account_balance.text
        expect(acc_balance_in_payment).to include(account_balance)
      end

      scenario '3. Verify the cart total is greater Account Balance' do
        cart_total = atg_checkout_payment_page.cart_total.text.delete('$').to_f
        expect(cart_total).to be > account_balance.delete('$').to_f
      end

      scenario '3. Verify PayPal button does not display on the Payment page' do
        expect(atg_checkout_payment_page.paypal_button_exist?).to eq(false)
      end
    end
  end
else
  feature 'Disable order purchasing in tests for the Preview and Production environments' do
    scenario 'Disable order purchasing for the <b>Preview</b> and <b>Production</b> environments' do
    end
  end
end
