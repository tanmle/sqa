require File.expand_path('../../spec_helper', __FILE__)
require 'atg_home_page'
require 'atg_login_register_page'
require 'atg_my_profile_page'
# require 'csc_login_page'
# require 'csc_home_page'

=begin
Verify that user can register a new account successfully
=end

# initial variables
atg_home_page = HomeATG.new
atg_register_page = nil
atg_my_profile_page = nil
# csc_login_page = LoginCSC.new
# csc_home_page = nil
cookie_session_id = nil

# account information variables
email = Data::EMAIL_GUEST_CONST
first_name = Data::FIRSTNAME_CONST
last_name = Data::LASTNAME_CONST
password = Data::PASSWORD_CONST
country = Data::COUNTRY_CONST
registered_account_info = "#{first_name} #{last_name} #{email} #{country}"

feature "TC01 - Account Management - New registration - ENV = '#{Data::ENV_CONST}' - Locale = '#{Data::LOCALE_CONST}'", js: true do
  # Go to App Center page
  before :all do
    cookie_session_id = atg_home_page.load
  end

  context 'Print Session ID' do
    scenario '' do
      pending "***SESSION_ID: #{cookie_session_id}"
    end
  end

  context 'On Account Registration page' do
    scenario '1. Go to register/login page' do
      atg_register_page = atg_home_page.goto_login
    end

    scenario '2. Select to create new account' do
      atg_my_profile_page = atg_register_page.register(first_name, last_name, email, password, password)
    end

    scenario 'Print generated email for future reference' do
      pending "***EMAIL #{email}"
    end

    scenario '3. Verify My Profile page displays' do
      expect(atg_my_profile_page.my_profile_page_exist?).to eq(true)
    end
  end

  context 'On My profile page' do
    scenario '1. Go to Account information page' do
      atg_my_profile_page.goto_account_information
      atg_my_profile_page.goto_account_information2  # (This line required for Bug ATG #12497)
    end

    scenario '2. Verify account information is correct' do
      expect(atg_my_profile_page.get_account_info).to eq(registered_account_info)
    end
  end

  # removing csc context for holiday support
  # context 'On CSC page' do
  #  scenario '1. Login to CSC page' do
  #    csc_home_page = csc_login_page.login(Data::CSC_USERNAME_CONST, Data::CSC_PASSWORD_CONST)
  #    csc_home_page.show_sidebar
  #  end

  #  scenario "2. Search customer by email - #{email}" do
  #    csc_home_page.search_customer_by_email(email)
  #  end

  #  scenario '3. Verify account that already created can be found on CSC' do
  #    expect(csc_home_page.get_customer_info).to eq(csc_customer_info)
  #  end
  # end
end
