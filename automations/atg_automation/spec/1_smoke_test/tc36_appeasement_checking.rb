require File.expand_path('../../spec_helper', __FILE__)
require 'atg_home_page'
require 'atg_login_register_page'
require 'atg_my_profile_page'
require 'atg_checkout_page'
require 'atg_checkout_shipping_page'
require 'atg_checkout_payment_page'
require 'atg_checkout_review_page'
require 'atg_checkout_confirmation_page'
require 'csc_login_page'
require 'csc_home_page'
require 'vin_login_page'
require 'vin_home_page'
require 'vin_common_page'
require 'vin_search_transactions_page'
require 'vin_transaction_detail_page'

=begin
Check appeasement on CSC tool
=end

# initial variables
atg_home_page = HomeATG.new
atg_login_page = nil
atg_my_profile_page = nil
atg_checkout_page = nil
atg_shipping_page = nil
atg_payment_page = nil
atg_review_page = nil
atg_confirmation_page = nil

# initial variables
csc_login_page = LoginCSC.new
csc_home_page = nil
vin_login_page = LoginVIN.new
vin_home_page = nil
vin_transaction_detail_page = nil

# Appeasement information variable
code_cr = 'CR'
amount = 1
order_total1, order_total2 = nil
note1 = "note1_#{Generate.get_current_time}"
note2 = "note2_#{Generate.get_current_time}"
vin_id1, vin_id2 = nil

# Order ID information
order_id_fulfill_balance = 'lfou13800157'
order_id_fulfill_paypal = 'lfou13800008'
order_id_fulfill_balance_paypal = 'lfou13800044'
order_id_fulfill_credit_card = nil
order_id_fulfill_cr_balance = 'lfou13700043'
is_status_fulfilled = false
prod_info = nil
pending_note = ''
cookie_session_id = nil

feature 'TC36 - Appeasement Checking' do
  context 'Pre-Condition: Create a Order with payment method is Credit Card' do
    it '1. Go to App Center page' do
      # 1. Login to App Center page
      cookie_session_id = atg_home_page.load

      # 2. Get random product info
      prod_info = atg_home_page.get_random_product_info
    end

    it 'Print Session ID' do
      pending "***SESSION_ID: #{cookie_session_id}"
    end

    it '2. Login to an existing account' do
      atg_login_page = atg_home_page.goto_login
      atg_my_profile_page = atg_login_page.login(Data::EMAIL_EXIST_FULL_CONST, Data::PASSWORD_CONST)
    end

    it '3. Add random product to cart' do
      atg_my_profile_page.add_to_cart prod_info[:id]
    end

    it '4. Go to Check out page' do
      atg_checkout_page = atg_my_profile_page.goto_checkout
    end

    it '5. Enter Shipping information' do
      atg_shipping_page = atg_checkout_page.check_out_as_logged_in_account
      atg_shipping_page.choose_shipping_method ProductInformation::SHIPPING_METHOD_CONST
      atg_shipping_page.get_shipping_method_checked
    end

    it '6. Check out by using Credit Card' do
      atg_payment_page = atg_shipping_page.shipping_as_full_information_account
      atg_review_page = atg_payment_page.pay_as_full_information_account
    end

    it '7. Place order and get Order ID' do
      atg_confirmation_page = atg_review_page.place_order
      order_id_fulfill_credit_card = atg_confirmation_page.get_order_id
      atg_confirmation_page.record_order_id Data::EMAIL_EXIST_FULL_CONST
    end
  end

  context 'Login to CSC page' do
    it '1. Login to CSC page' do
      csc_home_page = csc_login_page.login(Data::CSC_USERNAME_CONST, Data::CSC_PASSWORD_CONST)
    end

    it '2. Show Search slide bar' do
      csc_home_page.show_sidebar
    end
  end

  context 'Verify that CSR can not add appeasement if payment method is not Credit Card' do
    it "1. Verify Add Appeasement link does not enable - Account Balance - Order ID = '#{order_id_fulfill_balance}'" do
      csc_home_page.find_order_by_id order_id_fulfill_balance
      expect(csc_home_page.add_appeasement_lnk_exist?).to eq(false)
    end

    it "2. Verify Add Appeasement link does not enable - Paypal - Order ID = '#{order_id_fulfill_paypal}'" do
      csc_home_page.find_order_by_id order_id_fulfill_paypal
      expect(csc_home_page.add_appeasement_lnk_exist?).to eq(false)
    end

    it "3. Verify Add Appeasement link does not enable - Account Balance + Paypal - Order ID = '#{order_id_fulfill_balance_paypal}'" do
      csc_home_page.find_order_by_id order_id_fulfill_balance_paypal
      expect(csc_home_page.add_appeasement_lnk_exist?).to eq(false)
    end
  end

  context 'CSR can add appeasement if payment method is Credit Card only' do
    # Make the test poll every minute for the status update to a maximum of 16 minutes.
    before :all do
      is_status_fulfilled = csc_home_page.wait_for_change_order_status(order_id_fulfill_credit_card, 'Fulfilled', 60, 60 * 16)
      pending_note = "Order status does not change to Fulfilled - Order ID = '#{order_id_fulfill_credit_card}'"
    end

    it "1. Verify order status is changed to Fulfilled - Order ID = '#{order_id_fulfill_credit_card}'" do
      if !is_status_fulfilled
        pending pending_note
        fail
      end
    end

    it '2. Verify add appeasement link enable' do
      if is_status_fulfilled
        csc_home_page.find_order_by_id order_id_fulfill_credit_card
        expect(csc_home_page.add_appeasement_lnk_exist?).to eq(true)

        # Get VIN id and order total
        order_total1 = csc_home_page.order_view.order_total_txt.text
        vin_id1 = csc_home_page.order_view.vin_order_id_txt.text
      else
        pending pending_note
        fail
      end
    end

    it '3. On Order detail view, click on Add New Appeasement' do
      if is_status_fulfilled
        csc_home_page.click_add_appeasement_lnk
      else
        pending pending_note
        fail
      end
    end

    it '4. Enter data into Amount, Notes fields' do
      if is_status_fulfilled
        csc_home_page.add_new_appeasement(code_cr, amount, note1)
      else
        pending pending_note
        fail
      end
    end

    it '5. Verify a new record is added in Appeasement area with correct Reason Code, Amount and Notes' do
      if is_status_fulfilled
        csc_home_page.has_xpath?(OrderAppeasementSection::APPEASEMENT_RECORD_CONST % [code_cr, note1, amount])
      else
        pending pending_note
        fail
      end
    end

    it '6. Verify Order total is not updated' do
      if is_status_fulfilled
        expect(csc_home_page.order_view.order_total_txt.text).to eq(order_total1)
      else
        pending pending_note
        fail
      end
    end
  end

  context "CSR can add appeasement if payment method is Credit Card + Account Balance - Order ID = '#{order_id_fulfill_cr_balance}'" do
    it '1. Search Order ID' do
      # Search Order by ID
      csc_home_page.find_order_by_id order_id_fulfill_cr_balance

      # Get VIN id and order total
      order_total2 = csc_home_page.order_view.order_total_txt.text
      vin_id2 = csc_home_page.order_view.vin_order_id_txt.text
    end

    it '2. Verify add appeasement link enable for Credit Card method' do
      # Verify that add appeasement enable for order which payment method is Credit Card
      expect(csc_home_page.add_appeasement_lnk_exist?(1)).to eq(true)
    end

    it '3. Verify add appeasement link disable for Account Balance method' do
      # Verify that add appeasement enable for order which payment method is Credit Card
      expect(csc_home_page.add_appeasement_lnk_exist?(2)).to eq(false)
    end

    it '4. Add New Appeasement for Credit Card method' do
      # Click on Add New Appeasement link
      csc_home_page.click_add_appeasement_lnk(1)

      # Enter data into Amount, Notes fields
      csc_home_page.add_new_appeasement(code_cr, amount, note2)
    end

    it '5. Verify a new record is added in Appeasement area - Credit Card method' do
      csc_home_page.has_xpath?(OrderAppeasementSection::APPEASEMENT_RECORD_CONST % [code_cr, note2, amount])
    end

    it '6. Verify Order total is not updated - Credit Card method' do
      expect(csc_home_page.order_view.order_total_txt.text).to eq(order_total2)
    end

    it '7. Verify Order total is not updated - Account Balance method' do
      expect(csc_home_page.order_view.order_total_txt.text).to eq(order_total2)
    end

    after :all do
      csc_home_page.logout_administrator
    end
  end

  context 'On Vindicia page' do
    before :all do
      vin_home_page = vin_login_page.login(Data::VIN_USERNAME_CONST, Data::VIN_PASSWORD_CONST)
    end

    context 'Check information on Vindicia page - Credit Card only' do
      it "1. Verify order status is changed to Fulfilled - Order ID = '#{order_id_fulfill_credit_card}'" do
        if !is_status_fulfilled
          pending pending_note
          fail
        end
      end

      it '2. Search transaction' do
        if is_status_fulfilled
          vin_search_transactions_page = vin_home_page.go_to_search_transactions_page
          vin_transaction_detail_page = vin_search_transactions_page.search_transaction(vin_id1)
        else
          pending pending_note
          fail
        end
      end

      it '3. Verify Activity History displays/records transaction log' do
        if is_status_fulfilled
          vin_transaction_detail_page.has_xpath?(TransactionDetailVIN::REFUND_NOTE_CONST % note1)
        else
          pending pending_note
          fail
        end
      end
    end

    context "Check information on Vindicia page - Credit Card + Account Balance - Order ID = '#{order_id_fulfill_cr_balance}'" do
      it '1. Search transaction' do
        vin_search_transactions_page = vin_home_page.go_to_search_transactions_page
        vin_transaction_detail_page = vin_search_transactions_page.search_transaction(vin_id2)
      end

      it '2. Verify Activity History displays/records transaction log' do
        vin_transaction_detail_page.has_xpath?(TransactionDetailVIN::REFUND_NOTE_CONST % note2)
      end
    end
  end
end
