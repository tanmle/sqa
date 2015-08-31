class CustomerManagement
  attr_accessor :wsdl
  CONST_CALLER_ID = ENV['CONST_CALLER_ID']

  def initialize(env = 'QA')
    @wsdl = CommonMethods.get_wsdl ENV['CONST_CUSTOMER_MGT'], env
  end

  # Register Customer
  def register_customer(screen_name, email, username)
    CommonMethods.soap_call(
      @wsdl,
      :register_customer,
      "<caller-id>#{CONST_CALLER_ID}</caller-id>
      <customer id='' first-name='LTRC' last-name='Tester' middle-name='mdname' salutation='sal' locale='en_US' alias='LTRCTester' screen-name='#{screen_name}' modified='' created=''>
        <email>#{email}</email>
        <credentials username='#{username}' password='123456' hint='123456' expiration='2015-12-30T00:00:00' last-login=''/>
      </customer>"
    )
  end

  # Fetch Customer
  def fetch_customer(customer_id)
    CommonMethods.soap_call(
      @wsdl,
      :fetch_customer,
      "<caller-id>#{CONST_CALLER_ID}</caller-id>
      <username/>
      <customer-id>#{customer_id}</customer-id>"
    )
  end

  # Search for customer
  def search_for_customer(first_name, last_name, email)
    CommonMethods.soap_call(
      @wsdl,
      :search_for_customer,
      "<caller-id>#{CONST_CALLER_ID}</caller-id>
      <customer-first-name>#{first_name}</customer-first-name>
      <customer-last-name>#{last_name}</customer-last-name>
      <customer-email>#{email}</customer-email>"
    )
  end

  # Update Customer
  def update_customer(customer_id, username, email, password, screen_name)
    CommonMethods.soap_call(
      @wsdl,
      :update_customer,
      "<caller-id>#{CONST_CALLER_ID}</caller-id>
      <username>#{username}</username>
      <customer-id>#{customer_id}</customer-id>
      <customer id='111' first-name='uLTRC' last-name='uTester' middle-name='' salutation='' locale='fr_FR' alias='' screen-name='#{screen_name}' modified='' created='' type='' registration-date=''>
        <credentials username='#{username}' password='#{password}' hint='' expiration='' last-login='' password-temporary='?'/>
        <email>#{email}</email>
      </customer>"
    )
  end

  #
  # call updateCustomer service with full info
  #
  def update_customer_full_info(customer_id, firstname, lastname, middle, salutation, locale, _alias, screen, email, phone_msg, addr_msg, username, password, password_hint)
    CommonMethods.soap_call(
      @wsdl,
      :update_customer,
      "<caller-id>#{CONST_CALLER_ID}</caller-id>
      <customer-id>#{customer_id}</customer-id>
      <customer id=\'#{customer_id}\' first-name=\'#{firstname}\' last-name=\'#{lastname}\' middle-name=\'#{middle}\' salutation=\'#{salutation}\' locale=\'#{locale}\' alias=\'#{_alias}\' screen-name=\'#{screen}\'>
        <email>#{email}</email>#{phone_msg}#{addr_msg}<credentials username=\'#{username}\' password=\'#{password}\' hint=\'#{password_hint}\'/>
      </customer>"
    )
  end

  # Identify Customer
  def lookup_customer_by_username(username)
    CommonMethods.soap_call(
      @wsdl,
      :lookup_customer_by_username,
      "<caller-id>#{CONST_CALLER_ID}</caller-id>
      <username>#{username}</username>"
    )
  end

  #
  # get customer id by email
  # return: customer id if exist, else render error
  #
  def get_customer_id(email)
    search_res = search_for_customer('', '', email)
    return search_res.xpath('//customer/@id').text if search_res.is_a?(Nokogiri::XML::Document)
    search_res
  end
end
