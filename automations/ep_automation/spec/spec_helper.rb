$LOAD_PATH.unshift('automations/lib')
$LOAD_PATH.unshift('automations/ep_automation')
$LOAD_PATH.unshift('automations/ep_automation/lib')

require 'const'
require 'test_driver_manager'

module Capybara
  class << self
    alias_method :old_reset_sessions!, :reset_sessions!

    def reset_sessions!
    end
  end
end

xml_content = File.read $LOAD_PATH.detect { |path| path.index('data.xml') } || 'TEMPORARY DATA FILE IS MISSING. PLEASE RECHECK!'
webdriver = Nokogiri::XML(xml_content).search('//webdriver').text # FIREFOX, CHROME, IE or WEBDRIVER

case webdriver
when 'FIREFOX'
  TestDriverManager.run_with(:firefox)
when 'CHROME'
  TestDriverManager.run_with(:chrome)
when 'IE'
  TestDriverManager.run_with(:internet_explorer)
else
  TestDriverManager.run_with(:webkit)
end
