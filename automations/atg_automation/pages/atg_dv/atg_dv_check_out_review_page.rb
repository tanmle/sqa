require 'pages/atg_dv/atg_dv_common_page'
require 'pages/atg_dv/atg_dv_check_out_confirmation_page'

class AtgDvCheckOutReviewPage < AtgDvCommonPage
  element :place_order_btn, :xpath, "(.//button[text()='Place Order'])[1]"
  element :sub_total_lbl, '#orderSubtotal'
  element :account_balance_lbl, '.orderAccountBalanceApplied .col-xs-4.col-sm-2.text-right'
  element :tax_lbl, '#orderTax'
  element :order_total_lbl, '.col-xs-4.col-sm-2.text-right .orderTotalCart'

  def dv_place_order
    place_order_btn.click
    sleep TimeOut::WAIT_MID_CONST * 2
    AtgDvCheckOutConfirmationPage.new
  end

  def dv_order_review_info
    account_balance = account_balance_lbl.text if has_account_balance_lbl?(TimeOut::WAIT_MID_CONST)
    {
      sub_total: sub_total_lbl.text,
      tax: tax_lbl.text,
      account_balance: account_balance,
      order_total: order_total_lbl.text
    }
  end
end
