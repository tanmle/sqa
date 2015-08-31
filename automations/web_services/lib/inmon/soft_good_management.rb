class SoftGoodManagement
  def self.reserve_gift_pin(caller_id = Misc::CONST_CALLER_ID, locale = 'en_US')
    LFCommon.soap_call(
      LFWSDL::CONST_SOFT_GOOD_MGT,
      :reserve_gift_pin,
      "<caller-id>#{caller_id}</caller-id>
      <locale>#{locale}</locale>"
    )
  end

  def self.purchase_gift_pin(caller_id, cus_id, pin)
    LFCommon.soap_call(
      LFWSDL::CONST_SOFT_GOOD_MGT,
      :purchase_gift_pin,
      "<caller-id>#{caller_id}</caller-id>
      <cust-key>#{cus_id}</cust-key>
      <references key='currency' value='USD'/>
      <references key='sku.count' value='1'/>
      <references key='locale' value='en_US'/>
      <references key='transactionId' value='transactionid_111'/>
      <references key='transactionAmount' value='10.00'/>
      <references key='sku.code_0' value='58129-96914'/>
      <reserved-pin>#{pin}</reserved-pin>"
    )
  end
end
