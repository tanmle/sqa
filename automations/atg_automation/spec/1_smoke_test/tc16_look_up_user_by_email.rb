require File.expand_path('../../spec_helper', __FILE__)
require 'atg_home_page'
require 'atg_login_register_page'
require 'atg_my_profile_page'
require 'csc_login_page'
require 'csc_home_page'
require 'csc_home_customer_infor_page.rb'

=begin
Verify user can search account information by email on CSC page
=end

# initial variables
atg_home_page = HomeATG.new
atg_register_page = nil
atg_my_profile_page = nil
csc_login_page = LoginCSC.new
csc_home_page = nil
csc_home_customer_info_page = nil
cookie_session_id = nil

# account information variables
email = Data::EMAIL_GUEST_CONST
first_name = Data::FIRSTNAME_CONST
last_name = Data::LASTNAME_CONST
password = Data::PASSWORD_CONST
address = nil

feature "TC05 - CSC - Look up user by email - ENV = '#{Data::ENV_CONST}' - Locale = '#{Data::LOCALE_CONST}'", js: true do
  # Go to App Center page
  before :all do
    cookie_session_id = atg_home_page.load
  end

  context 'Print Session ID' do
    scenario '' do
      pending "***SESSION_ID: #{cookie_session_id}"
    end
  end

  context 'Register a new account' do
    scenario '1. Go to register/login page' do
      atg_register_page = atg_home_page.goto_login
    end

    scenario '2. Select to create new account' do
      atg_my_profile_page = atg_register_page.register(first_name, last_name, email, password, password)
    end

    scenario '3. Verify My Profile page displays' do
      expect(atg_my_profile_page.my_profile_page_exist?).to eq(true)
    end

    scenario '4. Go to Account information page' do
      atg_my_profile_page.goto_account_information
    end

    scenario '5. Add new Address information' do
      address = Connection.my_sql_connection("select * from atg_address where locale like '%#{Data::LOCALE_CONST}%' ORDER BY RAND() LIMIT 1").fetch_hash
      atg_my_profile_page.add_new_address(
        first_name: CreditInfo::FIRST_NAME_CONST,
        last_name: CreditInfo::LAST_NAME_CONST,
        street: address['address1'],
        city: address['city'],
        state: address['state'],
        postal: address['postal'],
        phone_number: address['phone_number']
      )

      # Update info into atg_tracking table
      Connection.my_sql_connection("update atg_tracking set address1=\'#{address['address1']}\', updated_at=\'#{Time.now.strftime('%Y-%m-%d %H:%M:%S')}\' where email='#{email}';")
    end
  end

  context 'On CSC page - Search customer by Email' do
    scenario '1. Login csc page' do
      csc_login_page.load
      csc_home_page = csc_login_page.login(Data::CSC_USERNAME_CONST, Data::CSC_PASSWORD_CONST)
    end

    scenario '2. Search customer by customer ID' do
      csc_home_page.search_customer_by_email(email)
    end
  end

  context 'Verify Customer information results' do
    scenario '1. Verify login, last name, first name, email' do
      expect(csc_home_page.get_customer_info).to eq("#{email} #{first_name} #{last_name} #{email}")
    end

    scenario '2. Verify First name' do
      csc_home_customer_info_page = csc_home_page.view_customer_information(email, true)
      expect(csc_home_customer_info_page.customer_info.first_name_txt.text).to eq(first_name)
    end

    scenario '3. Verify Last name' do
      expect(csc_home_customer_info_page.customer_info.last_name_txt.text).to eq(last_name)
    end

    scenario '4. Verify Email address' do
      expect(csc_home_customer_info_page.customer_info.email_address_txt.text).to eq(email)
    end

    scenario '5. Verify Login email' do
      expect(csc_home_customer_info_page.customer_info.email_address_txt.text).to eq(email)
    end

    scenario '6. Verify Address' do
      expect(csc_home_customer_info_page.customer_info.addresses_txt.text).to eq("#{first_name} #{last_name} #{address['address1']} #{address['city']} #{address['state']} #{address['postal']} #{Data::COUNTRY_DETAIL_CONST} #{address['phone_number']}")
    end
  end
end
