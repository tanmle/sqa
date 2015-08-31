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
  def getFeatureCheckingParameters(locale, storefront, data)
    $name = "#{locale} - #{storefront}"
    $storefrontlink = storefront
    $locale = locale
    $appcenter_link = "http://#{locale}.#{TestInfor::CONST_ENV.gsub('prod','').gsub('qa','qa-')}appcenter.leapfrog.com/storefront/home.ep"
    $data = data
    $pt_query = "select * from ep_pricetier where locale = '#{locale}';"
    case storefront
    when StorefrontConst::CONST_STOREFRONT_LP
      $rs_query = "select * from ep_titles where (#{locale} = 'X' and (lpu = 'X' or lp2 = 'X' or lp1 = 'X') "
    when StorefrontConst::CONST_STOREFRONT_LE
      $rs_query = "select * from ep_titles where (#{locale} = 'X' and (lgs = 'X' or lex = 'X') "
    when StorefrontConst::CONST_STOREFRONT_LR
      $rs_query = "select * from ep_titles where (#{locale} = 'X' and lpr = 'X' "
    end #end case storefront
  end #end def
end

# This class is to process and run test cases
# Date created: 01/27/2014
class <<self
  def VerifyFeatureChecking
    storefront = $storefrontlink
    appcenter_link = $appcenter_link
    locale = $locale
    storefront = $storefrontlink
    pt_query = $pt_query
    
    feature "==== Check #{$name} ===", :js => true do
      webUtilities = WebContentUtilities.new
      encode = RspecEncode.new
      pdpArray = []
      count = 0
      before :all do
        
        #Go to app center
        webUtilities.go_appcenter appcenter_link
        
        #Go to storefront
        webUtilities.go_storefront storefront
      end #end before
        
      context "== Check number of items in list", :js => true do
        scenario "Check have at least 6 items in list", :js => true do
          count = page.all('div.productDetail').count
		      click_on('See All')
          expect(count).to be >=(6)
        end
      end

      $data.data_seek(0)
      $data.each_hash do |row|
        
        #Getting expected data in mysql
        con = Mysql.new MySQLConst::CONST_SERVER, MySQLConst::CONST_USERNAME, MySQLConst::CONST_PASSOWRD, MySQLConst::CONST_DATABASE, MySQLConst::CONST_PORT
        
        rs_query = $rs_query + "and sku = '#{row['sku']}');"
        #Getting titles expected data
        rs = con.query rs_query
       
        #Getting price tier based on au
        pt = con.query pt_query        
          
        con.close
        
        rs.each_hash do |rows|
          href = nil
          title = nil
          curriculum  =nil
          age = nil
          price = nil                    
          inpage = false 
          if $name.include? 'fr'
            age_string = Title.new.calculateagestring_fr rows
          else
            age_string = Title.new.calculateagestring rows
          end
          price_string = Title.new.calculateprice rows,pt   
          context "Check for #{$name} - SKU = #{rows['sku']} - #{rows['shorttitle']}", :js=>true do      
            inpage = false
            
            scenario "Checking product detail", :js =>true do
              #begin get data from website
              if pdpArray[0] == nil then
                page.should have_css('div.productDetail a')
                page.all('div.productDetail').each do |el|
                  within el do
                    title = find('a.title').text
                    href = find('a.title')['href']
                    curriculum = find('span.curriculum').text
                    age = find('span.age').text
                    if page.has_css?('p.price span.regularprice', :wait => 0)
                      price = find('p.price span.regularprice').text
                    else
                      price = find('p.price').text
                    end #end if
                    pdp = { :title => title, :href => href, :curriculum => curriculum, :age => age, :price => price }                  
                    pdpArray.push(pdp)
                  end #end within
                end #end all
              end #end if
            #end get data
            end
            
            #TIN.TRINH: assert sku in page
            scenario "Checking sku in page", :js=>true do
              inpage = false
              pdpArray.each do |pdp|
                if pdp[:href].include? rows['sku'].strip then
                  title = pdp[:title]
                  age = pdp[:age]
                  price = pdp[:price]
                  curriculum = pdp[:curriculum]
                  inpage = true
                  sku = pdp[:href]
                  break
                end
                #break if inpage == true
              end
              if inpage == true
                inpage.should equal true
              else
                raise Exception.new("Expected: This title with sku = #{row['sku']} is existed\nGot: This title is missing")
              end
            end #end scenario
              
            #TIN.TRINH: assert shorttitle
            scenario "Checking title \"#{rows['shorttitle']}\"", :js=>true do
              if inpage == true
                expect(encode.encode_title(title)).to eq(encode.encode_title(rows['shorttitle']))
              else
                pending("This title with sku = '#{rows['sku']}' is missing")
              end
            end #end scenario
             
            #TIN.TRINH: assert price
            scenario "Checking price \"#{price_string}\"", :js=>true do
              if inpage == true
                expect(price).to eq(encode.encode_price(price_string))
              else
                pending("This title with sku = '#{rows['sku']}' is missing")
              end  
            end #end scenario
              
            #TIN.TRINH: assert ages
            scenario "Checking age \"#{age_string}\"", :js=>true do
              if inpage == true
                expect(age).to eq(age_string)
              else
                pending("This title with sku = '#{rows['sku']}' is missing")
              end               
            end #end scenario
              
            #TIN.TRINH: assert curriculum
            scenario "Checking curriculum \"#{rows['curriculum']}\"", :js=>true do
              if inpage == true
                expect(curriculum).to eq(rows['curriculum'])
              else
                pending("This title with sku = '#{rows['sku']}' is missing")
              end               
            end #end scenario
          end #end context
        end #end each_hash
      end #end each_hash

    end #end feature
  end # end def
end
