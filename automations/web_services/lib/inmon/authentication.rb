class Authentication
  def self.acquire_service_session(caller_id, username, password)
    LFCommon.soap_call(
      LFWSDL::CONST_AUTHENTICATION,
      :acquire_service_session,
      "<caller-id>#{caller_id}</caller-id>
       <credentials username='#{username}' password='#{password}' hint='' expiration=''/>"
    )
  end

  def self.get_service_session(caller_id, username, password)
    acq_ses_response = acquire_service_session(caller_id, username, password)
    acq_ses_response.xpath('//session').text
  end

  def self.register_login(caller_id, session, customer_id, customer_name)
    LFCommon.soap_call(
      LFWSDL::CONST_AUTHENTICATION,
      :register_login,
      "<caller-id>#{caller_id}</caller-id>
      <session type='service'>#{session}</session>
      <customer-id>#{customer_id}</customer-id>
      <customer-name>#{customer_name}</customer-name>
      <source>?</source>"
    )
  end

  def self.verify_service_session(caller_id, session)
    LFCommon.soap_call(
      LFWSDL::CONST_AUTHENTICATION, :verify_service_session,
      "<caller-id>#{caller_id}</caller-id>
      <session type='service'>#{session}</session>)"
    )
  end
end
