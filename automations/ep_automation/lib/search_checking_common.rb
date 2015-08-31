require 'mysql'
require 'selenium-webdriver'
require 'capybara/rspec'
require 'rspec/expectations'
require 'rspec'
require 'localesweep' # this is where helper methods are stored for locale sweep
require 'lfcontentutilities.rb'
require 'const'
require 'encode'
require 'dataconvert'

def get_search_parameters(locale, storefront)
  pt_query = "select * from ep_pricetier where locale = '#{locale}';"
  url = TestInfor.get_storefront_url locale, storefront
  case storefront
  when StorefrontConst::CONST_STOREFRONT_LP
    rs_query = "select * from #{TableName::CONST_TITLE_TABLE} where golivedate = '#{TestInfor::CONST_RELEASE}' and (#{locale} = 'X' and (lpu = 'X' or lp2 = 'X' or lp1 = 'X')) ;"
  when StorefrontConst::CONST_STOREFRONT_LE
    rs_query = "select * from #{TableName::CONST_TITLE_TABLE} where golivedate = '#{TestInfor::CONST_RELEASE}' and (#{locale} = 'X' and (lgs = 'X' or lex = 'X'));"
  when StorefrontConst::CONST_STOREFRONT_LR
    rs_query = "select * from #{TableName::CONST_TITLE_TABLE} where golivedate = '#{TestInfor::CONST_RELEASE}' and (#{locale} = 'X' and lpr = 'X') ;"
  end
  { pt_query: pt_query, url: url, rs_query: rs_query }
end

def get_search_parameters_fr(locale, storefront)
  if locale == 'fr-row'
    pt_query = "select * from ep_pricetier where locale = '#{locale[3, 3]}';"
  else
    if locale == 'fr-ca'
      pt_query = "select * from ep_pricetier where locale = '#{locale[3, 2]}';"
    else
      pt_query = "select * from ep_pricetier where locale = '#{locale}';"
    end
  end
  url = TestInfor.get_storefront_url_fr locale, storefront
  locale = locale.sub('-', '_')
  case storefront
  when StorefrontConst::CONST_STOREFRONT_LP_FR
    rs_query = "select * from #{TableName::CONST_TITLE_FR} where golivedate = '#{TestInfor::CONST_RELEASE}' and (#{locale} = 'X' and (lpu = 'X' or lp2 = 'X' or lp1 = 'X')) ;"
  when StorefrontConst::CONST_STOREFRONT_LE_FR
    rs_query = "select * from #{TableName::CONST_TITLE_FR} where golivedate = '#{TestInfor::CONST_RELEASE}' and (#{locale} = 'X' and (lgs = 'X' or lex = 'X')) ;"
  end
  { pt_query: pt_query, url: url, rs_query: rs_query }
end

class << self
  def verify_search_pdp(locales, storefronts, english = true)
    encode = RspecEncode.new
    web_utilities = WebContentUtilities.new
    feature "Search and PDP checking EP content", js: true do
      locales.each do |locale|
        storefronts.each do |storefront|
          if english
            params = get_search_parameters locale, storefront
          else
            params = get_search_parameters_fr locale, storefront
          end
          
          url = params[:url]
          rs_query = params[:rs_query]
          pt_query = params[:pt_query]
  
          # Getting expected data in mysql
          con = Mysql.new MySQLConst::CONST_SERVER, MySQLConst::CONST_USERNAME, MySQLConst::CONST_PASSOWRD, MySQLConst::CONST_DATABASE, MySQLConst::CONST_PORT
          rs = con.query rs_query
          total = rs.count
  
          # Getting price tier based on au
          pt = con.query pt_query
          con.close if con
          context "#{locale} - #{storefront} checking - #{TestInfor::CONST_ENV} - Total SKUs: #{total}", js: true do
            if total == 0
              it 'There is no app available.' do
              end
            else
              before :all do
                # Go to storefront
                web_utilities.go_to url
              end
  
              # Starting getting output data
              id = 0
              rs.data_seek(0)
              rs.each_hash do |row|
                context "#{id += 1} - SKU = #{row['sku']} - #{row['shorttitle']}", js: true do
                  title = nil
                  curriculum = nil
                  age = nil
                  price = nil
                  if english
                    age_string = Title.new.calculateagestring row
                  else
                    age_string = Title.new.calculateagestring_fr row
                  end
                  price_string = Title.new.calculateprice row, pt
                  sku_inpage = false
                  lsproduct_detail = []
  
                  # Process product description in page
                  scenario "Validation for found title of SKU = #{row['sku']}", js: true do
                    web_utilities.enter_sku(row['sku'].strip)
                    if page.has_xpath?("//div[@class='productDetail']/a[contains(@href,'#{row['sku'].strip}')]", wait: 0)
                      lsproduct_detail = page.all('div.productDetail')
                      lsproduct_detail.each do |el|
                        within el do
                          sku_inpage = true
                          title = find('a.title').text # get data for compare
                          curriculum = find('span.curriculum').text
                          age = find('span.age').text
                          if page.has_css?('p.price span.regularprice', wait: 0)
                            price = find('p.price span.regularprice').text
                          else
                            price = find('p.price').text
                          end
                          break
                        end
                      end
                      expect(sku_inpage).to eq true
                    else
                      raise Exception.new("Expected: This title with sku = #{row['sku']} is listed on search result page\nGot: This title is missing")
                    end
                  end
  
                  scenario 'Checking searching should return 1 title only', js: true do
                    if sku_inpage == true
                      lsproduct_detail.count.should equal 1
                    else
                      pending("This title with sku = '#{row['sku']}' is missing")
                    end
                  end
  
                  scenario "Checking title \"#{row['shorttitle']}\"", js: true do
                    if sku_inpage == true
                      expect(encode.encode_title(title).strip).to eq(encode.encode_title(row['shorttitle']).strip)
                    else
                      pending("This title with sku = '#{row['sku']}' is missing")
                    end
                  end
  
                  scenario "Checking price \"#{price_string}\"", js: true do
                    if sku_inpage == true
                      expect(price).to eq(encode.encode_price(price_string))
                    else
                      pending("This title with sku = '#{row['sku']}' is missing")
                    end
                  end
  
                  scenario "Checking age \"#{age_string}\"", js: true do
                    if sku_inpage == true
                      expect(age).to eq(age_string)
                    else
                      pending("This title with sku = '#{row['sku']}' is missing")
                    end
                  end
  
                  e_curriculum = (english) ? row['curriculum'] : DataConvert.convert_english_to_french('curriculum', row['curriculum'])
                  scenario "Checking curriculum \"#{e_curriculum}\"", js: true do
                    if sku_inpage == true
                      expect(curriculum).to eq(e_curriculum)
                    else
                      pending("This title with sku = '#{row['sku']}' is missing")
                    end
                  end
  
                  # ---Begin checking Product details page for found title
                  context "Checking Product Details Page for SKU = #{row['sku']}", js: true do
                    longdesc_pdp = nil
                    title_pdp = nil
                    age_pdp = nil
                    price_pdp = nil
  
                    # set variables for platform checking
                    has_icon_leappad = false
                    has_icon_leapster = false
                    has_icon_leapreader = false
  
                    has_leappad_ultra = ''
                    has_leappad2 = ''
                    has_leappad1 = ''
                    has_leapster_explorer = ''
                    has_leapster_gs = ''
                    has_leapreader = ''
  
                    img_string = ''
                    if english
                      age_string_pdp = Title.new.calculateagestringforPDP row
                    else
                      age_string_pdp = Title.new.calculateagestringforPDPFR row
                    end
                    price_string_pdp = Title.new.calculateprice row, pt
  
                    # Process product detail page information
                    scenario 'Checking product details page', js: true do
                      if sku_inpage == true
                        web_utilities.go_pdp(row['sku'])
                        title_pdp = find(:xpath, '//h1[@class="title"]').text
                        age_pdp = find(:xpath, '//p[@class="age"]').text
                        if page.has_xpath?("//div[@class='inset']//p[@class='price']//span[@class = 'regularprice']", wait: 0)
                          price_pdp = find(:xpath, "//div[@class='inset']//p[@class='price']//span[@class = 'regularprice']").text
                        else
                          price_pdp = find(:xpath, "//div[@class='inset']//p[@class='price']/span[@itemprop = 'price']").text
                        end
                        longdesc_pdp = find(:xpath, '//div[@class="description"]').text.chomp(' Credits')
  
                        # platform process
                        page.all(:xpath, "//*[@id='gaShortName']//p[@class='platform']//img").each do |img|
                          img_string += img['src']
                        end
  
                        # get platform text
                        platform_string = find(:xpath, "//*[@id='gaShortName']//p[@class='platform']/span[@class='platformTx']").text
  
                        # get actual result
                        has_icon_leappad = img_string.include? 'icon_device_lpad'
                        has_icon_leapster = img_string.include? 'icon_device_leapster_gs'
                        has_icon_leapreader = img_string.include? 'icon_device_leapreader'
  
                        has_leappad_ultra = (platform_string.downcase.include?('leappad ultra') || platform_string.downcase.include?('leappadultra')) ? 'x' : ''
                        has_leappad2 = (platform_string.downcase.include?('leappad 2') || platform_string.downcase.include?('leappad2')) ? 'x' : ''
                        has_leappad1 = (platform_string.downcase.include?('leappad 1') || platform_string.downcase.include?('leappad1')) ? 'x' : ''
                        has_leapster_explorer = (platform_string.downcase.include? 'leapster explorer') ? 'x' : ''
                        has_leapster_gs = (platform_string.downcase.include? 'leapstergs') ? 'x' : ''
                        has_leapreader = (platform_string.downcase.include? 'leapreader') ? 'x' : ''
                      else
                        pending("This title with sku = '#{row['sku']}' is missing")
                      end # end if
                    end
  
                    scenario "Checking long title '#{row['longtitle']}'", js: true do
                      if sku_inpage == true
                        expect(encode.encode_title(title_pdp).strip).to eq(encode.encode_title(row['longtitle']).strip)
                      else
                        pending("This title with sku = '#{row['sku']}' is missing")
                      end
                    end
  
                    scenario "Checking age '#{age_string_pdp}'", js: true do
                      if sku_inpage == true
                        expect(age_pdp).to eq(age_string_pdp)
                      else
                        pending("This title with sku = '#{row['sku']}' is missing")
                      end
                    end
  
                    scenario "Checking price '#{price_string_pdp}'", js: true do
                      if sku_inpage == true
                        expect(price_pdp).to eq(encode.encode_price(price_string_pdp))
                      else
                        pending("This title with sku = '#{row['sku']}' is missing")
                      end
                    end
  
                    scenario 'Checking long description', js: true do
                      if sku_inpage == true
                        expect(encode.process_longdesc(longdesc_pdp)).to eq(encode.process_longdesc(row['longdesc']))
                      else
                        pending("This title with sku = '#{row['sku']}' is missing")
                      end
                    end
  
                    scenario 'Checking works with icons', js: true do
                      if sku_inpage == true
                        # get expected platforms
                        ex_has_icon_leappad = (row['lpu'].downcase == 'x' || row['lp2'].downcase == 'x' || row['lp1'].downcase == 'x')
                        ex_has_icon_leapster = (row['lex'].downcase == 'x' || row['lgs'].downcase == 'x')
                        ex_has_icon_leapreader = (row['lpr'].downcase == 'x')
                        expect(has_icon_leappad).to eq(ex_has_icon_leappad)
                        expect(has_icon_leapster).to eq(ex_has_icon_leapster)
                        expect(has_icon_leapreader).to eq(ex_has_icon_leapreader)
                      else
                        pending("This title with sku = '#{row['sku']}' is missing")
                      end
                    end
  
                    scenario 'Checking works with platforms', js: true do
                      if sku_inpage == true
                        expect(has_leappad_ultra).to eq(row['lpu'].downcase)
                        expect(has_leappad2).to eq(row['lp2'].downcase)
                        expect(has_leappad1).to eq(row['lp1'].downcase)
                        expect(has_leapster_explorer).to eq(row['lex'].downcase)
                        expect(has_leapster_gs).to eq(row['lgs'].downcase)
                        expect(has_leapreader).to eq(row['lpr'].downcase)
                      else
                        pending("This title with sku = '#{row['sku']}' is missing")
                      end
                    end
  
                    scenario 'Check teaches', js: true do
                      if sku_inpage == true
                        e_teaches = row['teaches'].split(',').map(&:strip)
                        a_teaches = page.execute_script("return $('.skills a').text();").split('»').map(&:strip)
                        expect(a_teaches).to eq(e_teaches)
                      else
                        pending("This title with sku = '#{row['sku']}' is missing")
                      end
                    end
  
                    scenario 'Make sure that there is at least 1 YMAL', js: true do
                      if sku_inpage == true
                        page.should have_css('div#productDetailsFooter div.productDetail a', wait: 5)
                      else
                        pending("This title with sku = '#{row['sku']}' is missing")
                      end
                    end
                  end # ---End checking Product details page for found title
                end # end context parent
              end # end if total != 0
            end # end row.each
          end # end context
        end # end storefronts
      end # end locales
    end # end feature/describe
  end # end mothod
end # end class
