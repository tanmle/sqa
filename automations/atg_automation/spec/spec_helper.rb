$LOAD_PATH.unshift('automations/lib')
$LOAD_PATH.unshift('automations/atg_automation')
$LOAD_PATH.unshift('automations/atg_automation/pages/atg')
$LOAD_PATH.unshift('automations/atg_automation/pages/atg_dv')
$LOAD_PATH.unshift('automations/atg_automation/pages/csc')
$LOAD_PATH.unshift('automations/atg_automation/pages/vindicia')
$LOAD_PATH.unshift('automations/atg_automation/pages/mail')

require 'nokogiri'
require 'connection'
require 'test_driver_manager'
require 'lib/const'
require 'lib/encode'
require 'lib/excelprocessing'
require 'lib/generate'
require 'lib/localesweep'
require 'lib/services'
require 'lib/soft_good_common_methods'
require 'lib/atg_dv_common'

module Capybara
  class << self
    alias_method :old_reset_sessions!, :reset_sessions!

    def reset_sessions!
    end
  end
end

xml_content = Nokogiri::XML(File.read $LOAD_PATH.detect { |path| path.index('data.xml') }) || 'TEMPORARY DATA FILE IS MISSING. PLEASE RECHECK!'
web_driver = xml_content.search('//information/webdriver').text
device_store = xml_content.search('//devices/device_store').text.downcase

case device_store
when 'leappad3 en'
  user_agent = 'LeapPad3Explorer/6.0.11.361 (Linux Brio6.0.11.10831) Mozilla/5.0 (AppleWebKit/534.34 KHTML, like Gecko)'
when 'leappad3 fr'
  user_agent = 'LeapPad3Explorer/6.1.3.1070 (Linux Brio6.1.3.10948) Mozilla/5.0 (AppleWebKit/534.34 KHTML, like Gecko)'
when 'leappad ultra'
  user_agent = 'LeapPadUltra/5.2.7.1002 (Linux Brio4.3.1.10408) Mozilla/5.0 (AppleWebKit/534.34 KHTML, like Gecko, like Android) AppleWebKit/534.34'
when 'leappad platinum'
  user_agent = 'LeapPadPlatinum/8.0.2.3033 (Linux Brio8.0.2.6869) Mozilla/5.0 (AppleWebKit/534.34 KHTML, like Gecko)'
when 'narnia'
  user_agent = 'Narnia/KOT49H.eng..20150331.020400 Mozilla/5.0 (Linux; Android 4.4.2; EPICv1 Build/KOT49H) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/30.0.0.0 Safari/537.36'
else
  user_agent = ''
end

case web_driver
when 'FIREFOX'
  TestDriverManager.run_with(:firefox, user_agent)
when 'CHROME'
  TestDriverManager.run_with(:chrome, user_agent)
when 'IE'
  TestDriverManager.run_with(:internet_explorer, user_agent)
else
  TestDriverManager.run_with(:webkit, user_agent)
end

def app_exist?
  titles_count = Connection.my_sql_connection(AppCenterContent::CONST_QUERY_CHECK_APP_EXIST).count
  return true unless titles_count.zero?
  skip 'BLOCKED: No titles found in MOAS for this release'
  false
end

def app_available?(titles_count, message = 'There were no apps found in MOAS')
  return true unless titles_count.zero?
  it message do
  end
  false
end

def pin_available?(env, locale)
  code_env = (env.upcase == 'PROD') ? 'PROD' : 'QA'
  code_type = "#{locale.upcase}V1"
  pin = PinRedemption.get_pin_info(code_env, code_type, 'Available')

  return true unless pin.blank?

  skip 'BLOCKED: There is no available code in DB. Please upload code before running test case'
  false
end
