class Authentication
  attr_accessor :wsdl
  CONST_CALLER_ID = ENV['CONST_CALLER_ID']

  def initialize(env = 'QA')
    @wsdl = CommonMethods.get_wsdl ENV['CONST_AUTHENTICATION'], env
  end

  # acquireServiceSession
  def acquire_service_session(username, password)
    CommonMethods.soap_call(
      @wsdl,
      :acquire_service_session,
      "<caller-id>#{CONST_CALLER_ID}</caller-id>
      <credentials username='#{username}' password='#{password}' hint='' expiration=''/>"
    )
  end

  #
  # Get service session ID
  #
  def get_service_session(username, password)
    session_xml = CommonMethods.soap_call(
      @wsdl, :acquire_service_session,
      "<caller-id>#{CONST_CALLER_ID}</caller-id>
      <credentials username='#{username}' password='#{password}' hint='' expiration=''/>"
    )

    return session_xml if session_xml[0] == 'error'
    session_xml.at_xpath('//session').text
  end
end
