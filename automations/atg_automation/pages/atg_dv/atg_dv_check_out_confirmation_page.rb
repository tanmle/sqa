require 'pages/atg_dv/atg_dv_common_page'

class AtgDvCheckOutConfirmationPage < AtgDvCommonPage
  element :order_id_lbl, '.panel-body>p>strong'
  element :order_complete_msg, '.dary-grey'
  element :sub_total_lbl, '#orderSubtotal'
  element :account_balance_lbl, '.orderAccountBalanceApplied .col-xs-4.col-sm-2.text-right'
  element :tax_lbl, '#orderTax'
  element :order_total_lbl, '.col-xs-4.col-sm-2.text-right .orderTotalCart'

  def dv_order_confirmation_info
    account_balance = account_balance_lbl.text if has_account_balance_lbl?(TimeOut::WAIT_MID_CONST)
    {
      order_id: order_id_lbl.text.strip,
      message: order_complete_msg.text.strip,
      order_detail: {
        sub_total: sub_total_lbl.text,
        account_balance: account_balance,
        tax: tax_lbl.text,
        order_total: order_total_lbl.text
      }
    }
  end

  def record_order_id(email, order_id)
    temp_id = ''
    rs = Connection.my_sql_connection "select order_id from atg_tracking where email = '#{email}'"

    rs.each_hash do |row|
      if row['order_id'].nil?
        temp_id = order_id
      else
        temp_id = row['order_id'] + ', ' + order_id
      end
    end

    Connection.my_sql_connection "update atg_tracking set order_id = '#{temp_id}', updated_at = '#{Time.now.strftime('%Y-%m-%d %H:%M:%S')}' where email = '#{email}'"
  end
end
