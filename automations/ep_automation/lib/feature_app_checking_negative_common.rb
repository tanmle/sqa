require 'mysql'
require 'selenium-webdriver'
require 'capybara/rspec'
require 'rspec/expectations'
require 'rspec'
require 'localesweep'            # this is where helper methods are stored for locale sweep
require 'lfcontentutilities.rb'
require 'const'
require 'encode'

# TIN.TRINHThis class initiate needed parameters for testing
# Date created: 12/24/2013
class ProductAutomation
  # this method gets parameters for CS checking
  # locale: 'us', 'uk', 'au', 'ie', 'ca', 'row'
  # storefront: "LeapPad Apps", "Leapster Explorer Apps", "LeapReader Apps"
  def getFeatureStorefrontNegativeCheckingParameters(locale, storefront, data)
    $name = "#{locale} - #{storefront}"
    $storefrontlink = storefront
    $locale = locale
    $appcenter_link = "http://#{locale}.#{TestInfor::CONST_ENV.gsub('prod','').gsub('qa','qa-')}appcenter.leapfrog.com/storefront/home.ep"
    $data = data
    $pt_query = "select * from ep_pricetier where locale = '#{locale}';"
    case storefront
    when StorefrontConst::CONST_STOREFRONT_LP
      $rs_query = "select * from ep_titles where ((lpu = '' and lp2 = '' and lp1 = '') "
    when StorefrontConst::CONST_STOREFRONT_LE
      $rs_query = "select * from ep_titles where ((lgs = '' and lex = '') "
    when StorefrontConst::CONST_STOREFRONT_LR
      $rs_query = "select * from ep_titles where (lpr = '' "
    end #end case storefront
  end #end def
  
  
  def getFeatureStorefrontNegativeLocaleCheckingParameters(locale, storefront, data)
    $name = "#{locale} - #{storefront}"
    $storefrontlink = storefront
    $locale = locale
    $appcenter_link = "http://#{locale}.#{TestInfor::CONST_ENV.gsub('prod','').gsub('qa','qa-')}appcenter.leapfrog.com/storefront/home.ep"
    $data = data
    $pt_query = "select * from ep_pricetier where locale = '#{locale}';"
    case storefront
    when StorefrontConst::CONST_STOREFRONT_LP
      $rs_query = "select * from ep_titles where (#{locale}= '' and (lpu = 'X' or lp2 = 'X' or lp1 = 'X') "
    when StorefrontConst::CONST_STOREFRONT_LE
      $rs_query = "select * from ep_titles where (#{locale}= '' and (lgs = 'X' or lex = 'X') "
    when StorefrontConst::CONST_STOREFRONT_LR
      $rs_query = "select * from ep_titles where (#{locale}= '' and lpr = 'X' "
    end #end case storefront
  end #end def
end

# This class is to process and run test cases
# Date created: 01/27/2014
class <<self
  def VerifyFeatureNegativeChecking
    storefront = $storefrontlink
    appcenter_link = $appcenter_link
    locale = $locale
    storefront = $storefrontlink
    pt_query = $pt_query
    feature "==== #{$name} negative checking ===", :js => true do
      webUtilities = WebContentUtilities.new
      before :all do
        #Go to app center
        webUtilities.go_appcenter appcenter_link
        #Go to storefront
        webUtilities.go_storefront storefront

        click_on('See All')
  
      end #end before
        

      $data.data_seek(0)
      $data.each_hash do |row|
        _href = "/storefront/leappad-explorer/letter-factory-adventures-pathway-problem-solvers/prod"
        #Getting expected data in mysql
        con = Mysql.new MySQLConst::CONST_SERVER, MySQLConst::CONST_USERNAME, MySQLConst::CONST_PASSOWRD, MySQLConst::CONST_DATABASE, MySQLConst::CONST_PORT
        
        rs_query = $rs_query + "and sku = '#{row['sku']}');"
        #Getting titles expected data
        rs = con.query rs_query
       
        #Getting price tier based on au
        pt = con.query pt_query        
          
        con.close
                              
        rs.each_hash do |rows|
          
          if $name.include? 'fr'
            age_string = Title.new.calculateagestring_fr rows
          else
            age_string = Title.new.calculateagestring rows
          end
          price_string = Title.new.calculateprice rows,pt   
          scenario "Check for #{$name} - SKU = #{rows['sku']} - #{rows['shorttitle']} does not displays in feature page", :js=>true do
            if page.has_css?('div.productDetail a')
              sku_exist = page.has_xpath?("//a[@href='#{_href}#{rows['sku']}.html']", :wait => 0)
            else
              pending "Error loading page"
            end                                 
            sku_exist.should eq false
          end #end context
        end #end each_hash
      end #end each_hash
    end #end feature
  end # end def
end
