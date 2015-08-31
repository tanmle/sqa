require File.expand_path('../../spec_helper', __FILE__)
require 'atg_home_page'
require 'atg_login_register_page'
require 'atg_my_profile_page'

=begin
Verify that address information is checked while adding to account
=end

# initial variables
atg_home_page = HomeATG.new
atg_register_page = nil
atg_my_profile_page = nil
cookie_session_id = nil

# account information variables
address = nil
email = Data::EMAIL_GUEST_CONST
first_name = Data::FIRSTNAME_CONST
last_name = Data::LASTNAME_CONST
password = Data::PASSWORD_CONST

feature "TC04 - Account Management - Check address - ENV = '#{Data::ENV_CONST}' - Locale = '#{Data::LOCALE_CONST}'", js: true do
  # Go to App Center page
  before :all do
    cookie_session_id = atg_home_page.load
  end

  context 'Print Session ID' do
    scenario '' do
      pending "***SESSION_ID: #{cookie_session_id}"
    end
  end

  context 'Register new account' do
    scenario '1. Go to register/login page' do
      atg_register_page = atg_home_page.goto_login
    end

    scenario '2. Select to create new account' do
      atg_my_profile_page = atg_register_page.register(first_name, last_name, email, password, password)
    end

    scenario '3. Verify My Profile page displays' do
      expect(atg_my_profile_page.my_profile_page_exist?).to eq(true)
    end
  end

  context 'Add a bad address to account' do
    scenario '1. Go to Account information page' do
      atg_my_profile_page.goto_account_information
    end

    scenario '2. Verify Account information page displays' do
      expect(atg_my_profile_page.my_profile_page_exist?).to eq(true)
    end

    scenario '3. Add new bad address information' do
      address = Connection.my_sql_connection("select * from atg_address where locale like '%#{Data::LOCALE_CONST}%' ORDER BY RAND() LIMIT 1").fetch_hash
      atg_my_profile_page.add_new_address(
        first_name: CreditInfo::FIRST_NAME_CONST,
        last_name: CreditInfo::LAST_NAME_CONST,
        street: Data::ADDRESS1_BAD_CONST,
        city: address['city'],
        state: address['state'],
        postal: address['postal'],
        phone_number: address['phone_number']
      )

      # Update info into atg_tracking table
      Connection.my_sql_connection("update atg_tracking set address1=\'#{Data::ADDRESS1_BAD_CONST}\', updated_at=\'#{Time.now.strftime('%Y-%m-%d %H:%M:%S')}\' where email='#{email}';")
    end

    scenario '4. Verify address information' do
      expect(atg_my_profile_page.get_address_info_on_confirm_page).to eq("#{Data::ADDRESS1_BAD_CONST}  #{address['city']} #{address['state']} #{address['postal']} #{Data::LOCALE_CONST}")
    end

    scenario "5. Verify 'We could not find a valid address...' message displays" do
      expect(atg_my_profile_page.invalid_address_message?).to eq(true)
    end

    scenario "6. Verify 'Use Entered Address' button displays" do
      expect(atg_my_profile_page.address_confirm_popup_displayed?).to eq(true)
    end
  end

  # Delete all address
  after :all do
    atg_my_profile_page.delete_all_addresses
  end
end
