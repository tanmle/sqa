require 'pages/atg_dv/atg_dv_common_page'
require 'pages/atg_dv/atg_dv_check_out_payment_page'

class CheckOutLoginSection < SitePrism::Section
  element :login_txt, '#atg_loginPassword'
  element :continue_btn, :xpath, ".//button[text()='Continue']"
end

class AtgDvCheckOutPage < AtgDvCommonPage
  section :check_out_login_section, CheckOutLoginSection, '.container-fluid.ng-scope'
  element :check_out_btn, :xpath, ".//*[@id='moveToPurchase']/button[text()='Check Out']"
  element :lf_account_pass_lbl, :xpath, ".//h1[contains(text(),'LeapFrog Parent Account Password')]"
  element :hand_on_msg, :xpath, ".//h1[text()='Hang on!']"
  element :buy_btn, :xpath, ".//button[contains(text(),'Buy')]"

  def dv_go_to_payment_page(password)
    return unless has_check_out_btn?(wait: TimeOut::WAIT_MID_CONST)

    check_out_btn.click
    buy_btn.click if has_hand_on_msg?(wait: TimeOut::WAIT_MID_CONST)

    if has_lf_account_pass_lbl?(wait: TimeOut::WAIT_MID_CONST * 2)
      check_out_login_section.login_txt.set password
      check_out_login_section.continue_btn.click
      sleep TimeOut::WAIT_MID_CONST
    end

    AtgDvCheckOutPaymentPage.new
  end
end
