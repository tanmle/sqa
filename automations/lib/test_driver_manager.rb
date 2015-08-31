require 'rspec'
require 'capybara'
require 'capybara/rspec'
require 'selenium-webdriver'
require 'capybara/dsl'

class TestDriverManager
  def self.run_with(driver, user_agent = '')
    if driver == :webkit
      config_rspec_with_webkit user_agent
    else
      config_rspec_with_selenium driver, user_agent
    end
  end

  def self.config_rspec_with_webkit(user_agent)
    require 'capybara-webkit'
    require 'capybara/webkit/connection'
    require 'capybara/webkit/browser'

    RSpec.configure do |config|
      connection = Capybara::Webkit::Connection.new
      config.before :all do
        Capybara.register_driver :webkit do |app|
          browser = Capybara::Webkit::Browser.new(connection)
          browser.timeout = 600
          browser.url_blacklist = ['https://www.facebook.com', 'http://www.facebook.com']
          browser.ignore_ssl_errors
          browser.header('user-agent', user_agent) unless user_agent.empty?
          Capybara::Webkit::Driver.new(app, browser: browser)
        end

        Capybara.javascript_driver = :webkit
        Capybara.default_driver = :webkit
        Capybara.default_wait_time = 10
      end

      config.after :all do
        TestDriverManager.kill_webkit_server(connection.pid)
      end
    end
  end

  def self.config_rspec_with_selenium(driver = :firefox, user_agent = '')
    file_path = File.expand_path File.dirname(__FILE__)
    RSpec.configure do |config|
      config.before :all do
        case driver
        when :internet_explorer
          Selenium::WebDriver::IE.driver_path = "#{file_path}/IEDriverServer.exe"
        when :chrome
          Selenium::WebDriver::Chrome::Service.executable_path = "#{file_path}/chromedriver.exe"
        end

        Capybara.register_driver :selenium do |app|
          client = Selenium::WebDriver::Remote::Http::Default.new
          client.timeout = TimeOut::READTIMEOUT_CONST

          if user_agent.empty?
            Capybara::Selenium::Driver.new(app, browser: driver, http_client: client)
          else # Override User-Agent
            case driver
            when :firefox
              profile = Selenium::WebDriver::Firefox::Profile.new
              profile['general.useragent.override'] = user_agent
              Capybara::Selenium::Driver.new(app, browser: driver, http_client: client, profile: profile)
            when :chrome
              Capybara::Selenium::Driver.new(app, browser: driver, http_client: client, switches: %W[--user-agent=#{user_agent.gsub(/ /, '\ ')}])
            else # The IE driver does not support changing the user agent, using capabilities or otherwise
              Capybara::Selenium::Driver.new(app, browser: driver, http_client: client)
            end
          end
        end

        Capybara.javascript_driver = :selenium
        Capybara.default_driver = :selenium
        Capybara.default_wait_time = TimeOut::WAIT_CONTROL_CONST
        browser = Capybara.current_session.driver.browser
        browser.manage.delete_all_cookies
        browser.manage.window.maximize
      end
    end
  end

  def self.kill_webkit_server(pid)
    if Capybara.current_driver == :webkit
      Process.detach(pid)
      Process.kill('KILL', pid)
    end
  end

  def self.session_id
    begin
      if Capybara.default_driver == :webkit
        sessionid = page.driver.cookies['JSESSIONID']
      else
        cookies = Capybara.current_session.driver.browser.manage.all_cookies
        cookies.each do |cookie|
          sessionid = cookie[:value] if cookie[:name] == 'JSESSIONID'
        end
      end
    rescue => e
      sessionid = e.message
    end

    sessionid
  end
end
