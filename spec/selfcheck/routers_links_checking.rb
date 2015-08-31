require 'spec_helper'
require 'rspec'

describe 'TestCentral - Router/Links checking' do
  context DashboardController, type: :controller do
    it 'Check GET #dashboard/index' do
      get :index
      response.should be_success
    end

    it 'Check GET #dashboard/refresh_env' do
      get :refresh_env
      response.should be_success
    end

    it 'Check GET #dashboard/env_versions' do
      get :env_versions
      response.should be_success
    end

    it 'Check GET #dashboard/test_run_details' do
      get :test_run_details
      response.should be_success
    end
  end

  context AccountsController, type: :controller do
    it 'Check GET #accounts/clear_account' do
      get :clear_account, { env: 'QA', account: { email: 'ltrc_2014922134120475dsd6_us@leapfrog.test', password: '123456' }, is_active: '1' }
      response.should be_success
    end

    it 'Check GET #accounts/link_devices' do
      get :link_devices
      response.should be_success
    end

    it 'Check GET #accounts/process_linking_devices' do
      get :process_linking_devices, { atg_ld_email: 'ltrc_atg_uat_us_empty_1231201495346@sharklasers.com', atg_ld_password: '123456', atg_ld_platform: 'leappad2', atg_ld_env: 'QA', atg_ld_autolink: 'true', atg_ld_children: '', atg_ld_deviceserial: '' }
      response.should be_success
    end

    it 'Check GET #accounts/fetch_customer' do
      get :fetch_customer, { cus_env: 'QA', user_email: 'ltrc_atg_uat_us_full_11272014105958@sharklasers.com', user_password: '123456' }
      response.should be_success
    end
  end

  context UsersController, type: :controller do
    it 'Check GET #user/signin' do
      post :signin
      response.should be_success
    end

    it 'Check GET #user/signout' do
      get :signout
      expect(response).to redirect_to('/signin')
    end

    it 'Check GET #user/create' do
      get :create
      response.should be_success
    end

    it 'Check POST #user/create' do
      post :create
      response.should be_success
    end

    it 'Check POST #user/create_qa' do
      post :create_qa, { email: 'ltrc_vn_1127201141025@sharklasers.com', first_name: 'LTRC', last_name: 'VN', password: '123456' }
      response.should be_success
    end

    it 'Check GET #user/logging' do
      get :logging
      response.should be_success
    end

    it 'Check POST #users/update_limit' do
      post :update_limit, { limit_log_paging: '15' }
      expect(response).to redirect_to('/users/logging')
    end
  end

  context EpsController, type: :controller do
    it 'Check GET #eps/upload_catalog' do
      get :upload_catalog
      response.should be_success
    end

    it 'Check POST #eps/upload_catalog' do
      post :upload_catalog
      response.should be_success
    end
  end

  context EpMoasImportingsController, type: :controller do
    it 'Check GET #ep_moas_importings/index' do
      get :index
      response.should be_success
    end

    it 'Check POST #ep_moas_importings/excel2mysql' do
      post :excel2mysql, { language: 'english', excel_file: '', commit: 'Import data', hid_selected_language: '' }
      response.should be_success
    end
  end

  context EpSoapImportingsController, type: :controller do
    it 'Check GET #ep_soap_importings/index' do
      get :index
      response.should be_success
    end

    it 'Check POST #ep_soap_importings/soap2db' do
      post :soap2db
      response.should be_success
    end
  end

  context AtgsController, type: :controller do
    it 'Check GET #atgs/atg_tracking_data' do
      get :atg_tracking_data, { 'env' => 'UAT', 'loc' => 'US' }
      response.should be_success
    end

    it 'Check GET #atgs/atgconfig' do
      get :atgconfig
      response.should be_success
    end

    it 'Check GET #atgs/process_config_account' do
      get :process_config_account, { empty_email: 'pm201409090848057us@leapfrog.test', empty_pass: '654321', credit_email: 'ltrc_atg_uat_us_612201410531@sharklasers.com', credit_pass: '123456', balance_email: 'pm201409090910038us@leapfrog.test', balance_pass: '123456', credit_balance_email: 'pm201409090840046us@leapfrog.test', credit_balance_pass: '123456' }
      expect(response).to redirect_to('/atgs/atgconfig')
    end

    it 'Check GET #atgs/process_config_paypal' do
      get :process_config_paypal, { p_email_us: 'hantr1_1352963954_per@yahoo.com', p_password_us: '352965367', p_email_ca: 'hant11_1352975031_per@yahoo.com', p_password_ca: '12345678', p_email_uk: 'hantr5_1352968322_per@yahoo.com', p_password_uk: '12345678', p_email_ie: 'hantr5_1352968322_per@yahoo.com', p_password_ie: '12345678', p_email_au: 'hantr6_1352969230_per@yahoo.com', p_password_au: '12345678', p_email_row: 'hantr7_1352969911_per@yahoo.com', p_password_row: '12345678' }
      expect(response).to redirect_to('/atgs/atgconfig')
    end

    it 'Check GET #atgs/upload_code' do
      get :upload_code
      response.should be_success
    end

    it 'Check GET #atgs/create_ts' do
      get :create_ts, { tsname: 'Test Content', tcs: '219,220,', tsId: '43' }
      response.should be_success
    end

    it 'Check POST #atgs/process_upload_code' do
      post :process_upload_code, { code_env: 'QA', file_name: 'USV5', code_file: '' }
      response.should be_success
    end
  end

  context AtgMoasImportingsController, type: :controller do
    it 'Check GET #atg_moas_importings/index' do
      get :index
      response.should be_success
    end

    it 'Check POST #atg_moas_importings/excel2mysql' do
      post :excel2mysql, { language: 'english', excel_file: '' }
      response.should be_success
    end
  end

  context ChecksumComparisonController, type: :controller do
    it 'Check GET #checksum_comparison/index' do
      get :index
      response.should be_success
    end

    it 'Check POST #checksum_comparison/get_checksum' do
      post :get_checksum, { excel_file: '', folder: 'upload file to temp folder', chk_header_only: '1' }
      response.should be_success
    end

    it 'Check POST #checksum_comparison/load_content' do
      post :load_content, { folder: '2014-06-26-CONTENT', commit: 'Load content', hid_selected_folder: '1' }
      response.should be_success
    end

    it 'Check GET #checksum_comparison/view_result' do
      get :view_result
      response.should be_success
    end
  end

  context DeviceLookupController, type: :controller do
    it 'Check GET #device_lookup/index' do
      get :index
      response.should be_success
    end
  end

  context GeoipLookupController, type: :controller do
    it 'Check GET #geoip_lookup/index' do
      get :index
      response.should be_success
    end
  end

  context PinsController, type: :controller do
    it 'Check GET #pins/redeem' do
      get :redeem
      response.should be_success
    end
  end

  context FetchPinAttributesController, type: :controller do
    it 'Check GET #index' do
      get :index
      response.should be_success
    end

    it 'Check GET #get_pins_status' do
      get :get_pins_status, { lf_pin: '3760-8170-9435-6418', pin_env: 'QA' }
      response.should be_success
    end
  end

  context RailsAppConfigController, type: :controller do
    it 'Check GET #rails_app_config/configuration' do
      get :configuration
      response.should be_success
    end

    it 'Check POST #rails_app_config/update_run_queue_option' do
      post :update_run_queue_option, { limit_number: '9', refresh_rate: '2' }
      response.should be_success
    end

    it 'Check POST #rails_app_config/update_email_queue_setting' do
      post :update_email_queue_setting, { email_refresh_rate: '5' }
      response.should be_success
    end

    it 'Check POST #rails_app_config/update_smtp_settings' do
      post :update_smtp_settings, { address: 'smtp.gmail.com', 'port' => '587', domain: 'testcentral.com', username: 'lflgautomation@gmail.com', password: '123456abc!', attachment_type: 'none' }
      response.should be_success
    end
  end

  context EmailRollupController, type: :controller do
    it 'Check GET #email_rollup/index' do
      get :index
      response.should be_success
    end

    it 'Check POST #email_rollup/configure_rollup_email' do
      post :configure_rollup_email, { type: 'dashboard', enabled: 'true', time_amount: '5', start_time: '01:31 PM', emails: '' }
      response.should be_success
    end
  end

  context SchedulerController, type: :controller do
    it 'Check GET #index' do
      get :index
      response.should be_success
    end

    it 'Check POST #scheduler/update_scheduler_status' do
      post :update_scheduler_status, { id: '1', status: '0' }
      expect(response).to redirect_to('/admin/scheduler')
    end

    it 'Check POST #scheduler/update_scheduler_location' do
      post :update_scheduler_location, { id: '1', location: 'http://192.180.191.44:3000' }
      expect(response).to redirect_to('/admin/scheduler')
    end
  end

  context SearchController, type: :controller do
    it 'Check GET #search/index' do
      get :index
      response.should be_success
    end
  end

  context StaticPagesController, type: :controller do
    it 'Check GET #static_pages/about' do
      get :about
      response.should be_success
    end
  end

  context StationsController, type: :controller do
    it 'Check GET #stations/index' do
      get :index
      response.should be_success
    end

    it 'Check POST #stations/update_machine_config' do
      get :update_machine_config, { station_name: '', network_name: 'LGDN13012-W7D01', ip_address: 'localhost', port: '3000' }
      response.should be_success
    end

    it 'Check GET #stations/station_list' do
      get :station_list
      response.should be_success
    end
  end
end
