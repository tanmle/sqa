require File.expand_path('../../spec_helper', __FILE__)

=begin
  Device stores: Verify that user can check out successfully with a new account by using Credit Card payment method
=end

env = Data::ENV_CONST.upcase
if env == 'PREVIEW' || env == 'PROD'
  feature 'Disable order purchasing in tests for the Preview and Production environments' do
    scenario 'Disable order purchasing for the <b>Preview</b> and <b>Production</b> environments' do
    end
  end
else
  require 'atg_home_page'
  require 'atg_dv_app_center_page'
  require 'atg_dv_check_out_page'
  require 'atg_dv_check_out_review_page'
  require 'atg_dv_check_out_confirmation_page'
  require 'atg_dv_my_account_page'
  require 'mail_home_page'
  require 'mail_detail_page'

  # initial variables
  atg_digital_web_home_page = HomeATG.new
  atg_dv_app_center_page = AtgDvAppCenterPage.new
  atg_dv_review_page = AtgDvCheckOutReviewPage.new
  atg_dv_my_account_page = AtgDvMyAccountPage.new
  mail_home_page = HomePageMail.new
  atg_dv_check_out_page = nil
  atg_dv_confirmation_page = nil
  cookie_session_id = ''

  # Account information
  first_name = Data::FIRSTNAME_CONST
  last_name = Data::LASTNAME_CONST
  email = Data::EMAIL_GUEST_CONST
  password = Data::PASSWORD_CONST

  prod_info = {}
  order_review_info = {}
  order_confirmation_info = {}
  order_email_info = {}
  checkout_status = true

  describe "DVST01 - #{Data::DEVICE_STORE_CONST} - Checkout - Purchase Flow - Credit Card - Registered User - Add Card at checkout - ENV = '#{Data::ENV_CONST}' - Locale = '#{Data::LOCALE_CONST}'", js: true do
    context 'Pre-Condition: Go to Digital Web App Center page and create new account' do
      scenario 'Go to AppCenter Digital Web page' do
        atg_digital_web_home_page.load
        pending("*** Go to AppCenter Digital Web page (URL: #{atg_digital_web_home_page.current_url})")
      end

      create_account_and_link_all_devices(first_name, last_name, email, password, password)
    end

    context 'Check out product with Credit Card' do
      before :each do
        skip 'SKIP: Error while checking out app' unless checkout_status
      end

      scenario '1. Go to Device Store App Center page' do
        cookie_session_id = atg_dv_app_center_page.load
        pending("***1. Go to Device Store App Center page (URL: #{atg_dv_app_center_page.current_url})")
      end

      scenario '' do
        pending "***SESSION_ID: #{cookie_session_id}"
      end

      scenario '2. Get random a product info' do
        prod_info = atg_dv_app_center_page.dv_get_random_product_info
        pending "***2. Get random a product info (Prod_ID = #{prod_info[:product_id]})"
      end

      scenario '3. Add app to Cart' do
        atg_dv_app_center_page.dv_add_to_cart_from_catalog prod_info[:product_id]
      end

      scenario '4. Go to Check Out page' do
        atg_dv_check_out_page = atg_dv_app_center_page.dv_go_to_check_out_page
        pending("***4. Go to Check Out page (URL: #{atg_dv_check_out_page.current_url})")
      end

      scenario '5. Go to Payment page' do
        atg_dv_payment_page = atg_dv_check_out_page.dv_go_to_payment_page(password)
        pending("***5. Go to Payment page (URL: #{atg_dv_payment_page.current_url})")
      end

      dv_check_out_method(email, Data::PAYMENT_TYPE_CONST)

      scenario '7. Get order information on Review page' do
        checkout_status = atg_dv_review_page.has_place_order_btn?(wait: TimeOut::WAIT_MID_CONST)

        fail 'Fails to check out App. Please re-check!' unless checkout_status

        order_review_info = atg_dv_review_page.dv_order_review_info
      end

      scenario '8. Click on Place Order button' do
        # Click on Place Order button
        atg_dv_confirmation_page = atg_dv_review_page.dv_place_order

        # Get Order information on Confirmation page
        order_confirmation_info = atg_dv_confirmation_page.dv_order_confirmation_info

        # Update Order id into atg_tracking table
        atg_dv_confirmation_page.record_order_id(email, order_confirmation_info[:order_id])
      end

      scenario '' do
        pending("***Order number = #{order_confirmation_info[:order_id]}")
      end
    end

    context 'Verify information on Confirmation page' do
      before :each do
        skip 'SKIP: Error while checking out app' unless checkout_status
      end

      scenario '1. Verify complete order message' do
        expect(order_confirmation_info[:message]).to match('Thank you. Your order has been completed')
      end

      scenario '2. Verify Order Sub total' do
        expect(order_confirmation_info[:order_detail][:sub_total]).to eq(order_review_info[:sub_total])
      end

      scenario '3. Verify Order Tax' do
        expect(order_confirmation_info[:order_detail][:tax]).to eq(order_review_info[:tax])
      end

      scenario '4. Verify Order Total' do
        expect(order_confirmation_info[:order_detail][:order_total]).to eq(order_review_info[:order_total])
      end

      if Data::PAYMENT_TYPE_CONST != 'Credit Card'
        scenario '5. Verify Account Balance' do
          expect(order_confirmation_info[:order_detail][:account_balance]).to eq(order_review_info[:account_balance])
        end
      end
    end

    context 'Verify order number displays on My Account page' do
      before :each do
        skip 'SKIP: Error while checking out app' unless checkout_status
      end

      scenario '1. Go to My Account page' do
        atg_dv_confirmation_page.dv_go_to_my_account
      end

      scenario '2. Verify Order number' do
        order_ids = atg_dv_my_account_page.dv_order_ids
        expect(order_ids).to include(order_confirmation_info[:order_id])
      end
    end

    context 'Verify information on Email page' do
      before :each do
        skip 'SKIP: Error while checking out app' unless checkout_status
      end

      scenario '1. Go to Email page' do
        mail_detail_page = mail_home_page.go_to_mail_detail email
        order_email_info = mail_detail_page.order_email_info
      end

      scenario '2. Verify Order number' do
        expect(order_email_info[:order_number]).to eq("ORDER NUMBER: #{order_confirmation_info[:order_id]}")
      end

      scenario '3. Verify Order Sub total' do
        expect(order_email_info[:order_sub_total]).to eq("Order subtotal: #{order_confirmation_info[:order_detail][:sub_total]}")
      end

      scenario '4. Verify Tax' do
        expect(order_email_info[:tax]).to eq("Tax: #{order_confirmation_info[:order_detail][:tax]}")
      end

      scenario '5. Verify Purchase Total' do
        expect(order_email_info[:order_total]).to eq("Purchase Total: #{order_confirmation_info[:order_detail][:order_total]}")
      end

      if Data::PAYMENT_TYPE_CONST != 'Credit Card'
        scenario '6. Verify Account Balance' do
          expect(order_email_info[:account_balance]).to eq("Account Balance #{order_confirmation_info[:order_detail][:account_balance].gsub('-', '– ')}")
        end
      end
    end
  end
end
