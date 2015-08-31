require 'mysql'
require 'selenium-webdriver'
require 'capybara/rspec'
require 'rspec/expectations'
require 'rspec'
require 'localesweep' # this is where helper methods are stored for locale sweep
require 'dataconvert'
require 'lfcontentutilities.rb'
require 'const'
require 'connection'

def get_search_parameters_negative(locale, storefront)
  url = TestInfor.get_storefront_url locale, storefront
  locale = locale.sub('-', '_')
  case storefront
  when StorefrontConst::CONST_STOREFRONT_LP
    rs_query = "select * from #{TableName::CONST_TITLE_TABLE} where golivedate = '#{TestInfor::CONST_RELEASE}' and (#{locale}='' or (lpu='' and lp2='' and lp1=''));"
  when StorefrontConst::CONST_STOREFRONT_LE
    rs_query = "select * from #{TableName::CONST_TITLE_TABLE} where golivedate = '#{TestInfor::CONST_RELEASE}' and (#{locale} = '' or (lgs = '' and lex = ''));"
  when StorefrontConst::CONST_STOREFRONT_LR
    rs_query = "select * from #{TableName::CONST_TITLE_TABLE} where golivedate = '#{TestInfor::CONST_RELEASE}' and (#{locale} = '' or lpr = '');"
  end
  { url: url, rs_query: rs_query }
end

def get_search_parameters_negative_fr(locale, storefront)
  url = TestInfor.get_storefront_url_fr locale, storefront
  locale = locale.sub('-', '_')
  case storefront
  when StorefrontConst::CONST_STOREFRONT_LP_FR
    rs_query = "select * from #{TableName::CONST_TITLE_FR} where golivedate = '#{TestInfor::CONST_RELEASE}' and (#{locale} = '' or (lp2 = '' and lp1 = '')) ;"
  when StorefrontConst::CONST_STOREFRONT_LE_FR
    rs_query = "select * from #{TableName::CONST_TITLE_FR} where golivedate = '#{TestInfor::CONST_RELEASE}' and (#{locale} = '' or (lgs = '' and lex = '')) ;"
  end
  { url: url, rs_query: rs_query }
end

class << self
  def verify_skus_are_not_on_locale_storefront(locales, storefronts, english = true)
    web_utilities = WebContentUtilities.new
    feature 'Search negative checking EP content', js: true do
      locales.each do |locale|
        storefronts.each do |storefront|
          if english
            params = get_search_parameters_negative locale, storefront
          else
            params = get_search_parameters_negative_fr locale, storefront
          end
          element_xpath = "//div[@class='productDetail']/a[contains(@href,'%s')]"
          rs_query = params[:rs_query]
          url = params[:url]
          con = Mysql.new MySQLConst::CONST_SERVER, MySQLConst::CONST_USERNAME, MySQLConst::CONST_PASSOWRD, MySQLConst::CONST_DATABASE, MySQLConst::CONST_PORT
          rs = con.query rs_query
          con.close if con
          total = rs.count
          context "#{locale} - #{storefront} checking - #{TestInfor::CONST_ENV} - Total SKUs: #{total}" do
            if total == 0
              it 'There is no app available.' do
              end
            else
              before :all do
                web_utilities.go_to url
              end

              context "Storefront = #{storefront}" do
                id = 0
                rs.data_seek(0)
                rs.each_hash do |row|
                  scenario "#{id += 1} - SKU: #{row['sku']} - #{row['shorttitle']}" do
                    web_utilities.enter_sku(row['sku'].strip)
                    if page.has_css?('div.productDetail a', wait: TimeOut::CONST_WAIT_CONTROL)
                      page.should_not have_xpath(element_xpath % [row['sku'].strip], wait: 0)
                    else
                      pending 'Error loading page'
                    end
                  end # end scenario
                end # end each data record
              end # end context
            end # end if total != 0
          end # end main context
        end # end storefronts
      end # end locales
    end # end feature/describe
  end # end def
end # end class
