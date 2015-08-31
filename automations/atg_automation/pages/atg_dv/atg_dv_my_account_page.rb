require 'pages/atg_dv/atg_dv_common_page'

class AtgDvMyAccountPage < AtgDvCommonPage
  elements :order_number_lbl, '.orderNumber>a'

  def dv_order_ids
    order_id_arr = []
    order_number_lbl.each do |order|
      order_id_arr.push(order.text.strip)
    end

    order_id_arr
  end
end
