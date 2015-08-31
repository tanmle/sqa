require File.expand_path('../../spec_helper', __FILE__)
require 'customer_management'
require 'device_management'
require 'pages/glasgow/glasgow_page'

=begin
Glasgow: Smoke test: login/register account and set up account information
=end

start_browser
glasgow_page = GlasGowPage.new
password = '123456'
platform = 'leapup'
device_registration_url = GLASGOW::CONST_GLASGOW_URL
pin = '1234'

describe "TS01 - LeapTV Smoke Test - Env: #{Misc::CONST_ENV}" do
  context 'TC01_001 - Login to an existing account' do
    screen_name = CustomerManagement.generate_screenname
    username = email = LFCommon.generate_email
    device_serial = DeviceManagement.generate_serial
    profile_arr = nil
    act_code = nil

    context "Register customer (URL: #{LFWSDL::CONST_CUSTOMER_MGT})" do
      cus_id, email_res, pass_res = nil

      before :all do
        register_cus_res = CustomerManagement.register_customer(Misc::CONST_CALLER_ID, screen_name, username, email)
        get_cus_res = CustomerManagement.get_customer_info(register_cus_res)
        cus_id = get_cus_res[:id]
        email_res = get_cus_res[:email]
        pass_res = get_cus_res[:password]
      end

      it 'Verify customer ID' do
        expect(cus_id.to_i).not_to eq(0)
      end

      it 'Verify customer Email correct' do
        expect(email_res).to eq(email)
      end

      it 'Verify Password correct' do
        expect(pass_res.to_s).to eq(password)
      end
    end

    context 'Register device and fetch device activation code' do
      act_code = nil

      it "Register device (URL: #{LFWSDL::CONST_DEVICE_MGT})" do
        DeviceManagement.register_device(Misc::CONST_CALLER_ID, device_serial, platform)
      end

      it "Get device activation code (URL: #{LFWSDL::CONST_DEVICE_MGT})" do
        fetch_dev_act_res = DeviceManagement.fetch_device_activation_code(Misc::CONST_CALLER_ID, device_serial)
        act_code = fetch_dev_act_res.xpath('//activation-code').text
      end

      it 'Verify activation-code is valid' do
        expect(act_code.length).to eq(6)
      end
    end

    context 'Device Registration' do
      context "1. Go to Device Registration page (URL: #{device_registration_url})" do
        # Go to Device Registration page
        is_reg_page_exist = nil

        before :all do
          glasgow_page.load(device_registration_url)
          is_reg_page_exist = glasgow_page.register_form.has_device_serial_txt?
        end

        it 'Verify Device Registration page displays' do
          expect(is_reg_page_exist).to eq(true)
        end
      end

      context '2. Submit device serial' do
        # Submit device serial
        dev_act_title = nil

        before :all do
          glasgow_page.register_device(device_serial)
          dev_act_title = glasgow_page.register_form.regcode_title.text
        end

        it 'Verify Device Activation code page displays' do
          pending "*** Verify Device Activation code page displays (URL: #{glasgow_page.current_url})"
          expect(dev_act_title).to eq('Enter the registration code from your TV')
        end
      end

      context '3. Submit device activation code' do
        val_dev_act_code, login_page_title = nil

        before :all do
          # Get device activation code
          val_dev_act_code = glasgow_page.register_form.act_code_txt.value

          # Submit device activation code
          glasgow_page.submit_act_code act_code
          login_page_title = glasgow_page.login_form.title.text
        end

        it 'Verify device activation code is' do
          expect(val_dev_act_code).to eq(act_code)
        end

        it 'Verify Login/Registration page displays' do
          pending "*** Verify Login/Registration page displays (URL: #{glasgow_page.current_url})"
          expect(login_page_title).to eq('Create a LeapFrog Account')
        end
      end

      context '4. Login to account' do
        create_pin_title = nil

        it 'Login account' do
          glasgow_page.login_account(username, password)
          create_pin_title = glasgow_page.create_parent_lock_form.step1_title.text
        end

        it 'Verify Create Parent PIN page displays' do
          pending "*** Verify Create Parent PIN page displays (URL: #{glasgow_page.current_url})"
          expect(create_pin_title).to eq('Create Parent Lock Code')
        end
      end

      context '5. Create parent PIN' do
        create_chile_title = nil
        before :all do
          # Create parent PIN
          glasgow_page.create_parent_pin pin
          create_chile_title = glasgow_page.create_profile_form.title.text
        end

        it 'Verify Create Child Profiles page displays' do
          pending "*** Verify Create Child Profiles page displays (URL: #{glasgow_page.current_url})"
          expect(create_chile_title).to eq('Who will play this LeapTV?')
        end
      end

      context '6. Create child profiles' do
        child_pro_created_title, reg_completed_title = nil

        it '1. Create random a child profile' do
          profile_arr = glasgow_page.create_random_child_profile
          child_pro_created_title = glasgow_page.create_profile_form.title.text
        end

        it 'Verify Child Profile Created page displays' do
          pending "*** Verify Child Profile Created page displays (URL: #{glasgow_page.current_url})"
          expect(child_pro_created_title).to eq('Child Profile Created')
        end

        it '2. Go to Registration Complete page' do
          glasgow_page.create_profile_form.done_btn.click
          reg_completed_title = glasgow_page.registration_complete_lbl.text
        end

        it 'Verify Registration Complete page displays' do
          pending "*** Verify Registration Complete page displays (URL: #{glasgow_page.current_url})"
          expect(reg_completed_title).to eq('Registration Complete!')
        end
      end
    end

    context 'Verify child profiles via Web Service' do
      profile_num, fetch_dev_info_arr = nil

      it "Fetch device profile info (URL: #{LFWSDL::CONST_DEVICE_MGT})" do
        # fetchDevice profile info
        fetch_dev_res = DeviceManagement.fetch_device(Misc::CONST_CALLER_ID, device_serial, platform)
        profile_num = fetch_dev_res.xpath('//device/profile').count
        fetch_dev_info_arr = DeviceManagement.get_children_node_values(fetch_dev_res, '//device/profile')
      end

      it 'Verify the number of profile is 1' do
        expect(profile_num).to eq(1)
      end

      it 'Verify child profile information' do
        expect(fetch_dev_info_arr).to eq(profile_arr)
      end
    end
  end

  context 'TC01_002 - Create new account' do
    first_name = 'ltrc'
    last_name = 'vn'
    year = '1991'
    locale = 'US'
    email = LFCommon.generate_email
    device_serial = DeviceManagement.generate_serial
    profile_arr = nil
    act_code = nil

    context 'Register device and fetch device activation code' do
      act_code = nil

      it "Register customer (URL: #{LFWSDL::CONST_CUSTOMER_MGT})" do
        DeviceManagement.register_device(Misc::CONST_CALLER_ID, device_serial, platform)
      end

      it "Get device activation code (URL: #{LFWSDL::CONST_DEVICE_MGT})" do
        fetch_dev_act_res = DeviceManagement.fetch_device_activation_code(Misc::CONST_CALLER_ID, device_serial)
        act_code = fetch_dev_act_res.xpath('//activation-code').text
      end

      it 'Verify activation-code is valid' do
        expect(act_code.length).to eq(6)
      end
    end

    context 'Device Registration' do
      context "1. Go to Device Registration page (URL: #{device_registration_url})" do
        is_reg_page_exist = nil

        before :all do
          # Go to Device Registration page
          glasgow_page.load(device_registration_url)
          is_reg_page_exist = glasgow_page.register_form.has_device_serial_txt?
        end

        it 'Verify Device Registration page displays' do
          expect(is_reg_page_exist).to eq(true)
        end
      end

      context '2. Submit device serial' do
        dev_act_title = nil
        before :all do
          # Submit device serial
          glasgow_page.register_device(device_serial)
          dev_act_title = glasgow_page.register_form.regcode_title.text
        end

        it 'Verify Device Activation code page displays' do
          pending "*** Verify Device Activation code page displays (URL: #{glasgow_page.current_url})"
          expect(dev_act_title).to eq('Enter the registration code from your TV')
        end
      end

      context '3. Submit device activation code' do
        val_dev_act_code, login_page_title = nil
        before :all do
          # Get device activation code
          val_dev_act_code = glasgow_page.register_form.act_code_txt.value

          # Submit device activation code
          glasgow_page.submit_act_code act_code
          login_page_title = glasgow_page.login_form.title.text
        end

        it 'Verify device activation code' do
          expect(val_dev_act_code).to eq(act_code)
        end

        it 'Verify Login/Registration page displays' do
          pending "*** Verify Login/Registration page displays (URL: #{glasgow_page.current_url})"
          expect(login_page_title).to eq('Create a LeapFrog Account')
        end
      end

      context '4. Create a new account' do
        cus_info_res = nil
        before :all do
          # Login account
          glasgow_page.create_new_account(first_name, last_name, email, email, password, password, '', year, locale)

          # Fetch customer info
          cus_info_res = CustomerManagement.search_for_customer(Misc::CONST_CALLER_ID, '', '', email)

          # Ensure DB is refresh in 3 seconds
          (1..3).each do
            break if cus_info_res.xpath('//customer').count > 0
            sleep 1
            cus_info_res = CustomerManagement.search_for_customer(Misc::CONST_CALLER_ID, '', '', email)
          end
        end

        it 'Verify account is created successfully' do
          expect(cus_info_res.xpath('//customer').attr('id').text).not_to be_empty
        end

        it 'Verify Email is correct' do
          expect(cus_info_res.xpath('//customer/credentials').attr('username').text).to eq(email)
        end

        it 'Verify First name is correct' do
          expect(cus_info_res.xpath('//customer').attr('first-name').text).to eq(first_name)
        end

        it 'Verify Last name is correct' do
          expect(cus_info_res.xpath('//customer').attr('last-name').text).to eq(last_name)
        end
      end

      context '5. Create parent PIN' do
        create_chile_title = nil

        before :all do
          # Create parent PIN
          glasgow_page.create_parent_pin pin
          create_chile_title = glasgow_page.create_profile_form.title.text
        end

        it 'Verify Create Child Profiles page displays' do
          pending "*** Verify Create Child Profiles page displays (URL: #{glasgow_page.current_url})"
          expect(create_chile_title).to eq('Who will play this LeapTV?')
        end
      end

      context '6. Create child profiles' do
        child_pro_created_title, reg_completed_title = nil

        it '1. Create random a child profile' do
          profile_arr = glasgow_page.create_random_child_profile
          child_pro_created_title = glasgow_page.create_profile_form.title.text
        end

        it 'Verify Child Profile Created page displays' do
          pending "*** Verify Child Profile Created page displays (URL: #{glasgow_page.current_url})"
          expect(child_pro_created_title).to eq('Child Profile Created')
        end

        it '2. Go to Registration Complete page' do
          glasgow_page.create_profile_form.done_btn.click
          reg_completed_title = glasgow_page.registration_complete_lbl.text
        end

        it 'Verify Registration Complete page displays' do
          pending "*** Verify Registration Complete page displays (URL: #{glasgow_page.current_url})"
          expect(reg_completed_title).to eq('Registration Complete!')
        end
      end
    end

    context 'Verify child profiles via Web Service' do
      profile_num, fetch_dev_info_arr = nil

      it "Fetch device profile info (URL: #{LFWSDL::CONST_DEVICE_MGT})" do
        fetch_dev_res = DeviceManagement.fetch_device(Misc::CONST_CALLER_ID, device_serial, platform)
        profile_num = fetch_dev_res.xpath('//device/profile').count
        fetch_dev_info_arr = DeviceManagement.get_children_node_values(fetch_dev_res, '//device/profile')
      end

      it 'Verify the number of profile is 1' do
        expect(profile_num).to eq(1)
      end

      it 'Verify child profile information' do
        expect(fetch_dev_info_arr).to eq(profile_arr)
      end
    end
  end
end
