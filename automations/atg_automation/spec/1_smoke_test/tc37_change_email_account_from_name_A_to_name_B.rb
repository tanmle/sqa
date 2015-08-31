require File.expand_path('../../spec_helper', __FILE__)
require 'csc_home_page.rb'
require 'csc_login_page.rb'
require 'atg_home_page'
require 'atg_login_register_page'
require 'atg_my_profile_page'
require 'atg_product_detail_page'
require 'atg_checkout_page'
require 'atg_checkout_confirmation_page'
require 'mail_detail_page.rb'
require 'mail_home_page.rb'

=begin
Verify user can check out after updating account information
=end

# initial variables
atg_home_page = HomeATG.new
atg_register_page = nil
atg_login_page = nil
atg_my_profile_page = nil
atg_checkout_page = nil
atg_shipping_page = nil
atg_payment_page = nil
atg_review_page = nil
atg_confirmation_page = nil
mail_home_page = HomePageMail.new
mail_detail_page = nil
order_id = nil
email_a = Data::EMAIL_GUEST_CONST
email_b = "change_#{email_a}"
cookie_session_id = nil

feature "TC37 - Change email account from name A(#{email_a}) to name B(#{email_b}) - ENV = '#{Data::ENV_CONST}' - Locale = '#{Data::LOCALE_CONST}'", js: true do
  context 'Case 1: Change email on ATG site' do
    context 'Precondition: Place an order on account A' do
      before :all do
        # Register new account
        cookie_session_id = atg_home_page.load
        atg_register_page = atg_home_page.goto_login
        atg_my_profile_page = atg_register_page.register(Data::FIRSTNAME_CONST, Data::LASTNAME_CONST, email_a, Data::PASSWORD_CONST, Data::PASSWORD_CONST)

        # Add new Address and Credit Card
        atg_my_profile_page.goto_account_information

        atg_my_profile_page.add_new_address(
          first_name: Data::FIRSTNAME_CONST,
          last_name: Data::LASTNAME_CONST,
          street: Data::ADDRESS1_CONST,
          city: Data::CITY_CONST,
          state: Data::STATE_CODE_CONST,
          postal: Data::ZIP_CONST,
          phone_number: Data::PHONE_CONST
        )

        credit_card = {
          card_number: Data::CARD_NUMBER_CONST,
          cart_type: Data::CARD_TYPE_CONST,
          name_on_card: Data::NAME_ON_CARD_CONST,
          exp_month: Data::EXP_MONTH_NAME_CONST,
          exp_year: Data::EXP_YEAR_CONST,
          security_code: Data::SECURITY_CODE_CONST
        }

        atg_my_profile_page.add_new_credit_card_with_new_billing(credit_card, nil)
      end

      scenario 'Print Session ID' do
        pending "***SESSION_ID: #{cookie_session_id}"
      end

      scenario '1. Add to cart' do
        atg_my_profile_page.remove_all_items_in_shop_cart
        atg_home_page = atg_my_profile_page.go_to_home_page
        atg_home_page.add_random_product_to_cart 1
      end

      scenario '2. Go to Check out page' do
        atg_checkout_page = atg_my_profile_page.goto_checkout
      end

      scenario '3. Go to Shipping page' do
        atg_shipping_page = atg_checkout_page.check_out_as_logged_in_account
      end

      scenario '4. Go to Payment page' do
        atg_payment_page = atg_shipping_page.shipping_as_full_information_account
      end

      scenario '5. Go to Review page' do
        atg_review_page = atg_payment_page.pay_as_full_information_account
      end

      scenario '6. Go to Confirmation page' do
        atg_confirmation_page = atg_review_page.place_order
        order_id = atg_confirmation_page.get_order_id
      end

      scenario '7. Verify complete order message' do
        expect(atg_confirmation_page.order_complete_txt.text).to match(ProductInformation::ORDER_COMPLETE_MESSAGE_CONST)
      end
    end

    context 'Change email address' do
      scenario '1. Change email address of account A to new email address( NEA)' do
        atg_my_profile_page = atg_home_page.goto_my_account
        atg_my_profile_page.goto_account_information
        atg_my_profile_page.edit_account_info(email_b)
      end

      scenario '2. On My Profile page, verify email is changed correspondingly' do
        expect(atg_my_profile_page.personal_info_box.email_txt.text).to eq(email_b)
      end

      scenario '3. On My Account, verify Order History( 1 completed order still remains)' do
        atg_my_profile_page.goto_my_account
        expect(atg_my_profile_page.my_account_form.in_process_tr.count).to eq(1)
        expect(atg_my_profile_page.my_account_form.first_in_progress_order_number_td.text).to eq(order_id)
      end

      scenario '4. updated confirmation email send to email NEA' do
        mail_detail_page = mail_home_page.go_to_mail_detail email_b, 1
        expect(mail_detail_page.update_success_txt.text).to include("Dear #{Data::FIRSTNAME_CONST} #{Data::LASTNAME_CONST}, Your LeapFrog account email has successfully been updated.")
      end
    end

    context 'Place order after changing email address' do
      before :all do
        atg_home_page.load
        atg_home_page.logout
        atg_login_page = atg_home_page.goto_login
        atg_my_profile_page = atg_login_page.login(email_b, Data::PASSWORD_CONST)
      end
      scenario '1. Add to cart' do
        atg_my_profile_page.remove_all_items_in_shop_cart
        atg_home_page = atg_my_profile_page.go_to_home_page
        atg_home_page.add_random_product_to_cart 1
      end

      scenario '2. Go to Check out page' do
        atg_checkout_page = atg_my_profile_page.goto_checkout
      end

      scenario '3. Go to Shipping page' do
        atg_shipping_page = atg_checkout_page.check_out_as_logged_in_account
      end

      scenario '4. Go to Payment page' do
        atg_payment_page = atg_shipping_page.shipping_as_full_information_account
      end

      scenario '5. Go to Review page' do
        atg_review_page = atg_payment_page.pay_as_full_information_account
      end

      scenario '6. Go to Confirmation page' do
        atg_confirmation_page = atg_review_page.place_order
      end

      scenario '7. Verify complete order message' do
        expect(atg_confirmation_page.order_complete_txt.text).to match(ProductInformation::ORDER_COMPLETE_MESSAGE_CONST)
      end
    end

    context 'Verify user cannot login with old email' do
      before :all do
        atg_home_page.load
        atg_home_page.logout
        atg_login_page = atg_home_page.goto_login
      end

      scenario '1. Login with old email' do
        atg_my_profile_page = atg_login_page.login(email_a, Data::PASSWORD_CONST)
      end

      scenario "2. Verify an error message 'The email address or password you entered is incorrect. Please try again' displays" do
        expect(atg_login_page.login_form.has_error_msg?).to eq(true)
      end
    end
  end
end
