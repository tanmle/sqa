require File.expand_path('../../spec/spec_helper', __FILE__)
require 'atg_dv_check_out_payment_page'
require 'atg_dv_check_out_review_page'
require 'mail_detail_page'

def dv_check_out_method(email, payment_method)
  atg_dv_payment_page = AtgDvCheckOutPaymentPage.new
  review_page = AtgDvCheckOutReviewPage.new

  credit_card = {
    card_number: Data::CARD_NUMBER_CONST,
    card_name: Data::NAME_ON_CARD_CONST,
    exp_month: Data::EXP_MONTH_NAME_CONST,
    exp_year: Data::EXP_YEAR_CONST,
    security_code: Data::SECURITY_CODE_CONST
  }

  billing_address = {
    street: Data::ADDRESS1_CONST,
    city: Data::CITY_CONST,
    state: Data::STATE_CODE_CONST,
    zip: Data::ZIP_CONST,
    phone: Data::PHONE_CONST
  }

  case payment_method
  when 'Credit Card'
    scenario '6. Check out with Credit Card' do
      # Add new Credit Card
      atg_dv_payment_page.dv_add_credit_card(credit_card, billing_address)

      # Select the added Credit Card
      atg_dv_payment_page.dv_select_credit_card

      update_info_account(email, billing_address[:street], credit_card[:card_number])
    end
  when 'Account Balance'
    scenario '6. Check out with Redeem Code' do
      atg_dv_payment_page.dv_redeem_code 3
    end
  else # Credit Card + Account Balance
    scenario '6. Check out with Credit Card + Account Balance' do
      # Add new Credit Card
      atg_dv_payment_page.dv_add_credit_card(credit_card, billing_address)

      # Redeem Code
      atg_dv_payment_page.dv_redeem_code

      # If Account Balance is not enough -> Pay with Credit Card + Account Balance
      atg_dv_payment_page.dv_select_credit_card unless review_page.has_place_order_btn?(wait: TimeOut::WAIT_MID_CONST * 2)

      update_info_account(email, billing_address[:street], credit_card[:card_number])
    end
  end
end
