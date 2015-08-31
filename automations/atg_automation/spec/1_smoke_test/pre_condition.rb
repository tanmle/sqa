require File.expand_path('../../spec_helper', __FILE__)
require 'atg_home_page'
require 'atg_login_register_page'
require 'atg_my_profile_page'

=begin
Pre-condition: Create an account with full information (address, credit card, link to all device) and an empty account
=end

# initial variables
atg_home_page = HomeATG.new
atg_register_page = nil
atg_my_profile_page = nil
cookie_session_id = nil

# Account info
full_email = Data::EMAIL_GUEST_FULL_CONST
empty_email = Data::EMAIL_GUEST_EMPTY_CONST
password = Data::PASSWORD_CONST
registered_account_infor = "ltrc vn #{full_email} #{Data::COUNTRY_CONST}"

# Web Service info
caller_id = ServicesInfo::CONST_CALLER_ID
device_serial_lpad = 'LPAD' + DeviceManagementService.generate_serial
device_serial_lpad2 = 'LPAD2' + DeviceManagementService.generate_serial
device_serial_lpad3 = 'LPAD3' + DeviceManagementService.generate_serial
device_serial_lex = 'LEX' + DeviceManagementService.generate_serial
device_serial_lr = 'LR' + DeviceManagementService.generate_serial
device_serial_gs = 'GS' + DeviceManagementService.generate_serial

feature "Pre condition - Create new accounts - ENV = '#{Data::ENV_CONST}' - Locale = '#{Data::LOCALE_CONST}'", js: true do
  # Go to App Center home page
  before :all do
    cookie_session_id = atg_home_page.load
  end

  context 'Print Session ID' do
    scenario '' do
      pending "***SESSION_ID: #{cookie_session_id}"
    end
  end

  context 'Create new account with full information' do
    scenario '1. Go to register/login page' do
      atg_register_page = atg_home_page.goto_login
    end

    scenario '2. Register a new account with full information' do
      atg_my_profile_page = atg_register_page.register(CreditInfo::FIRST_NAME_CONST, CreditInfo::LAST_NAME_CONST, full_email, password, password)
    end

    scenario '3. Verify My Profile page displays' do
      expect(atg_my_profile_page.my_profile_page_exist?).to eq(true)
    end

    # "On My profile page - add address - add credit card"
    scenario "4. Go to 'Account information' page" do
      atg_my_profile_page.goto_account_information
      atg_my_profile_page.goto_account_information2 # (This line required for Bug ATG #12497)
    end

    scenario '5. Verify Account information in My Profile page is correct' do
      expect(atg_my_profile_page.get_account_info).to eq(registered_account_infor)
    end

    scenario '6. Add new address information' do
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
      Connection.my_sql_connection("update atg_tracking set address1=\'#{address['address1']}\', updated_at=\'#{Time.now.strftime('%Y-%m-%d %H:%M:%S')}\' where email='#{full_email}';")
    end

    scenario '7. Add new Credit Card and Billing Address' do
      # Select Card info from database
      credit = Connection.my_sql_connection('select * from atg_credit ORDER BY RAND() LIMIT 1').fetch_hash

      # Add Card to account and Billing address
      atg_my_profile_page.add_new_credit_card_with_new_billing(
        card_number: credit['card_number'],
        cart_type: credit['card_type'],
        name_on_card: CreditInfo::NAME_ON_CARD_CONST,
        exp_month: CreditInfo::EXP_MONTH_NAME_CONST,
        exp_year: CreditInfo::EXPIRED_YEAR_CONST,
        security_code: CreditInfo::SECURITY_CARD_CONST
      )

      # Update info into atg_tracking table
      Connection.my_sql_connection("update atg_tracking set credit_number=\'#{credit['card_number']}\', exp_month='#{CreditInfo::EXPIRED_MONTH_CONST}', exp_year=#{CreditInfo::EXPIRED_YEAR_CONST}, updated_at=\'#{Time.now.strftime('%Y-%m-%d %H:%M:%S')}\' where email='#{full_email}';")
    end

    scenario '8. Log out' do
      # Log out account
      atg_my_profile_page.logout

      # Check if account logout successfully
      expect(atg_home_page.logout_successful?).to eq(true)
    end

    scenario '9. Link account to all devices' do
      # Get customer id
      search_res = CustomerManagement.search_for_customer(caller_id, full_email)
      cus_id = search_res.xpath('//customer/@id').text

      # acquire service session
      session_res = AuthenticationService.acquire_service_session(caller_id, full_email, password)
      session = session_res.xpath('//session').text

      # register child
      register_child_res = ChildManagementService.register_child(caller_id, session, cus_id)
      child_id = register_child_res.xpath('//child/@id').text

      # claim account to all devices
      # LPAD
      OwnerManagementService.claim_device(caller_id, session, device_serial_lpad, 'leappad', '0', 'LeapPad', child_id)
      DeviceProfileManagementService.assign_device_profile(caller_id, cus_id, device_serial_lpad, 'leappad', '0', 'LeapPad', child_id)

      # LPAD2
      OwnerManagementService.claim_device(caller_id, session, device_serial_lpad2, 'leappad2', '0', 'Val', child_id)
      DeviceProfileManagementService.assign_device_profile(caller_id, cus_id, device_serial_lpad2, 'leappad2', '0', 'Val', child_id)

      # LPAD3
      OwnerManagementService.claim_device(caller_id, session, device_serial_lpad3, 'leappad3', '0', 'Cabo', child_id)
      DeviceProfileManagementService.assign_device_profile(caller_id, cus_id, device_serial_lpad3, 'leappad3', '0', 'Cabo', child_id)

      # LEX
      OwnerManagementService.claim_device(caller_id, session, device_serial_lex, 'emerald', '0', 'LeapterExplore', child_id)
      DeviceProfileManagementService.assign_device_profile(caller_id, cus_id, device_serial_lex, 'emerald', '0', 'LeapterExplore', child_id)

      # Leapter GS
      OwnerManagementService.claim_device(caller_id, session, device_serial_gs, 'explorer2', '0', 'LeapterGS', child_id)
      DeviceProfileManagementService.assign_device_profile(caller_id, cus_id, device_serial_gs, 'explorer2', '0', 'LeapterGS', child_id)

      # Leap Reader
      OwnerManagementService.claim_device(caller_id, session, device_serial_lr, 'leapreader', '0', 'LeapReader', child_id)
      DeviceProfileManagementService.assign_device_profile(caller_id, cus_id, device_serial_lr, 'leapreader', '0', 'LeapReader', child_id)
    end
  end

  context 'Create new account with empty information' do
    scenario '1. Go to register/login page' do
      atg_register_page = atg_home_page.goto_login
    end

    scenario '2. Register an account' do
      atg_my_profile_page = atg_register_page.register(CreditInfo::FIRST_NAME_CONST, CreditInfo::LAST_NAME_CONST, empty_email, password, password)
    end

    scenario '3. Verify My Profile page should be displayed' do
      expect(atg_my_profile_page.my_profile_page_exist?).to eq(true)
    end
  end
end
