require 'pages/atg_dv/atg_dv_common_page'
require 'pages/atg_dv/atg_dv_check_out_review_page'

class CreditCardSection < SitePrism::Section
  element :card_name_txt, '#accountHolderName'
  element :card_number_txt, '#creditCardNumber'
  element :cc_exp_month_btn, '.cc-exp-month button'
  element :cc_exp_year_btn, '.cc-exp-year button'
  element :security_code, '#creditCardCvn'
end

class BillingAddressSection < SitePrism::Section
  element :street_txt, '#billingAddress1'
  element :street_2_txt, '#billingAddress2'
  element :city_txt, '#billingAddressCity'
  element :state_btn, '.cc-us-state>div>button'
  element :zip_code_txt, '#billingAddressPostalCode'
  element :phone_number_txt, '#billingAddressPhone'
  element :continue_btn, '#billingContinue'
end

class RedeemCodeSection < SitePrism::Section
  element :input1_txt, :xpath, ".//input[@name='uiRedeemCode1']"
  element :input2_txt, :xpath, ".//input[@name='uiRedeemCode2']"
  element :input3_txt, :xpath, ".//input[@name='uiRedeemCode3']"
  element :input4_txt, :xpath, ".//input[@name='uiRedeemCode4']"
  element :state_btn, '.mobile-dropdown__button'
  element :redeem_btn, '.btn.btn-primary.pull-right.redeem__btn-submit'
end

class CodeAcceptedSection < SitePrism::Section
  element :continue_btn, :xpath, ".//a[contains(text(),'Continue')]"
end

class AtgDvCheckOutPaymentPage < AtgDvCommonPage
  section :credit_card_section, CreditCardSection, '.row.form-narrow.hcenter'
  section :billing_address_section, BillingAddressSection, '.row.form-narrow.hcenter'
  section :redeem_code_section, RedeemCodeSection, '.redeemForm1'
  section :code_accepted_section, CodeAcceptedSection, '.section-fluid'

  element :redeem_now_btn, :xpath, ".//a[contains(text(),'Redeem Now')]"
  element :add_new_credit_card_btn, :xpath, ".//a[contains(text(), 'Add New Credit Card')]"
  element :continue_btn, :xpath, ".//button[text()='Continue']"
  element :first_credit_card_chk, :xpath, "(.//input[@name='selectedSavedCreditCard'])[1]"
  element :use_this_credit_card_btn, :xpath, ".//button[text()='Use this Credit Card']"
  element :pin_redeemed_error, :xpath, ".//div[contains(text(),'Sorry, this code has already been redeemed.')]"

  def dv_enter_credit_card(credit_card)
    credit_card_section.card_name_txt.set credit_card[:card_name]
    credit_card_section.card_number_txt.set credit_card[:card_number]

    credit_card_section.cc_exp_month_btn.click
    find(:xpath, ".//*[@class='mobile-dropdown__list']/li[text()='#{credit_card[:exp_month]}']").click

    credit_card_section.cc_exp_year_btn.click
    find(:xpath, ".//*[@class='mobile-dropdown__list']/li[text()='#{credit_card[:exp_year]}']").click

    credit_card_section.security_code.set credit_card[:security_code]
  end

  def dv_enter_billing_address(billing_address)
    billing_address_section.street_txt.set billing_address[:street]
    billing_address_section.city_txt.set billing_address[:city]

    billing_address_section.state_btn.click
    find(:xpath, ".//*[@class='mobile-dropdown__list']/li[contains(text(),'#{billing_address[:state]} -')]").click

    billing_address_section.zip_code_txt.set billing_address[:zip]
    billing_address_section.phone_number_txt.set billing_address[:phone]
  end

  def dv_add_credit_card(credit_card, billing_address = nil)
    add_new_credit_card_btn.click

    dv_enter_credit_card credit_card
    dv_enter_billing_address billing_address

    continue_btn.click
    has_use_this_credit_card_btn?(wait: TimeOut::WAIT_CONTROL_CONST)
  end

  def dv_select_credit_card
    first_credit_card_chk.click
    use_this_credit_card_btn.click
    AtgDvCheckOutReviewPage.new
  end

  def dv_redeem_code(repeat_time = 1)
    env = (Data::ENV_CONST.upcase == 'PROD') ? 'PROD' : 'QA'
    locale = Data::LOCALE_CONST.upcase
    code_type = "#{locale}V1"
    state = (locale == 'US') ? 'Alaska' : 'Alberta'

    repeat_time.times do
      redeem_now_btn.click

      pin = PinRedemption.get_pin_info(env, code_type, 'Available')
      return 'Please upload the PIN to redeem' if pin.blank?

      # Update PIN status to Used
      pin_number = pin['pin_number']
      PinRedemption.update_pin_status(env, code_type, pin_number, 'Used')

      # Enter PIN values
      redeem_code_section.input1_txt.set pin_number[0..3]
      redeem_code_section.input2_txt.set pin_number[5..8]
      redeem_code_section.input3_txt.set pin_number[10..13]
      redeem_code_section.input4_txt.set pin_number[15..18]

      # Select State
      redeem_code_section.state_btn.click
      find(:xpath, ".//*[@class='mobile-dropdown__list']/li[contains(text(),'#{state}')]").click

      # Click on Redeem button
      redeem_code_section.redeem_btn.click
      sleep TimeOut::WAIT_MID_CONST

      return "The PIN: #{pin_number} has been redeemed" if has_pin_redeemed_error?(wait: TimeOut::WAIT_MID_CONST)

      # Click on Continue button on Code Accepted page
      code_accepted_section.continue_btn.click if code_accepted_section.has_continue_btn?(wait: TimeOut::WAIT_BIG_CONST)

      review_page = AtgDvCheckOutReviewPage.new
      return review_page if review_page.has_place_order_btn?(wait: TimeOut::WAIT_MID_CONST * 2)
    end

    'Error while redeem code. Please upload Code to redeem!'
  end
end
