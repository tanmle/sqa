require 'mysql'
require 'selenium-webdriver'
require 'capybara/rspec'
require 'rspec/expectations'
require 'rspec'
require 'localesweep' # this is where helper methods are stored for locale sweep
require 'lfcontentutilities.rb'
require 'const'
require 'encode'

# Date created: 12/24/2013 Updated at: 12/16/2014
def get_cs_checking_parameters(locale, storefront, cscode)
  url = TestInfor.get_storefront_url locale, storefront
  cscode = cscode.gsub('-', '')

  # Get expected titles for CS checking
  case storefront
  when StorefrontConst::CONST_STOREFRONT_LP
    rs_query = "select sku, shorttitle from #{TableName::CONST_TITLE_TABLE}
                 where (pricetier like 'Tier 0.5%' or pricetier like 'Tier 1%' or pricetier like 'Tier 2%' or pricetier like 'Tier 3 %')
                 and lower(licnonlic) = 'non-licensed'
                 and #{locale} = 'X'
                 and (lpu = 'X' or lp2 = 'X' or lp1 = 'X')
                 and golivedate != '0000-00-00';"
  when StorefrontConst::CONST_STOREFRONT_LE
    rs_query = "select sku, shorttitle from #{TableName::CONST_TITLE_TABLE}
                 where (pricetier like 'Tier 0.5%' or pricetier like 'Tier 1%' or pricetier like 'Tier 2%' or pricetier like 'Tier 3 %')
                 and lower(licnonlic) = 'non-licensed'
                 and #{locale} = 'X'
                 and (lgs = 'X' or lex = 'X')
                 and golivedate != '0000-00-00';"
  when StorefrontConst::CONST_STOREFRONT_LR
    rs_query = "select sku, shorttitle from #{TableName::CONST_TITLE_TABLE}
                 where (pricetier like 'Tier 0.5%' or pricetier like 'Tier 1%' or pricetier like 'Tier 2%' or pricetier like 'Tier 3 %')
                 and lower(licnonlic) = 'non-licensed'
                 and #{locale} = 'X'
                 and (lpr = 'X')
                 and golivedate != '0000-00-00' ;"
  end
  { url: url, rs_query: rs_query, cscode: cscode }
end

class <<self
  def verify_cs_checking(locales, storefronts, cscode)
    encode = RspecEncode.new
    web_utilities = WebContentUtilities.new
    feature 'CS check ep content automation', js: true do
      locales.each do |locale|
        storefronts.each do |storefront|
          params = get_cs_checking_parameters locale, storefront, cscode
          url = params[:url]
          rs_query = params[:rs_query]
          cscode = params[:cscode]
          cs_array = []
          i = 0
          context "#{locale} - #{storefront} checking - #{TestInfor::CONST_ENV}", js: true  do
            con = Mysql.new MySQLConst::CONST_SERVER, MySQLConst::CONST_USERNAME, MySQLConst::CONST_PASSOWRD, MySQLConst::CONST_DATABASE, MySQLConst::CONST_PORT

            # Excute getting titles expected data
            rs = con.query rs_query
            con.close if con

            before :all do
              # Go to storefront
              web_utilities.go_to url

              # Login and redeem cs code
              web_utilities.redeem Account::CONST_USERNAME, Account::CONST_PASSWORD, cscode

              # handle if Message 717 displays
              if page.has_css?('div#modalredeem_error', wait: 3)
                # 1. close "redeem code" popup
                page.find(:xpath, ".//*[@id='modalredeem']/a").click

                # 2. call redeem method
                web_utilities.redeem Account::CONST_USERNAME, Account::CONST_PASSWORD, cscode
              end
            end

            # Starting getting output data
            rs.each_hash do |row|
              context "SKU = #{row['sku']} - #{row['shorttitle']} in total #{rs.num_rows} apps", js: true do
                srcmd = nil # src of medium image
                srclg = nil # src of large image
                title = nil
                titleexist = false

                # Process CS checking after redeeming
                scenario '== Check the list of apps appear on subset dialog', js: true do
                  if cs_array[0].nil?
                    if page.has_xpath? "//a[@id='productLink']/div/img"
                      page.all(:xpath, "//a[@id='productLink']/div/img", visible: false).each do |el|
                        srcmd = el['src']
                        el.click
                        srclg = page.find(:xpath, "//div[@id='selectedProductImage']/img")['src']
                        title = page.find(:xpath, "//h1[@id='selectedProductTitle']").text
                        cs = { srcmd: srcmd, srclg: srclg, title: title }
                        cs_array.push(cs)
                      end
                    end
                    srcmd = nil # src of medium image
                    srclg = nil # src of large image
                    title = nil
                  end
                end

                # Check title after redeeming cs code
                scenario "== Check title \"#{row['shorttitle']}\" of app ", js: true do
                  cs_array.each do |cs|
                    next unless cs[:title].downcase.include? encode.encode_title(row['shorttitle']).downcase
                    titleexist = true
                    title = cs[:title]
                    srcmd = cs[:srcmd]
                    srclg = cs[:srclg]
                    break
                  end
                  expect(titleexist).should eq true
                end

                # Check image of titles after redeeming cs code
                # Make sure that is no dead image
                # Make sure medium image and large image is corresponding
                scenario '== Check image of title is correct', js: true do
                  if titleexist
                    expect(srcmd).to include '_md'
                    expect(srclg).to include '_lg'
                    expect(srcmd.gsub('_md', '_lg')).to eq(srclg)
                  else
                    pending 'This title is not existed or wrong in appcenter site'
                  end
                end
              end # end context
            end # end row.each

            context '=== List apps that exist on app site but do not exist or do not map with expected' do
              scenario '== Check the number of apps of subset dialog and expected' do
                expect(cs_array.count).to eq(rs.num_rows)
              end

              scenario '== The titles that are redundant or do not map between app site and expected:' do
                pending_string = ''
                cs_array.each do |cs|
                  rs.data_seek(0)
                  titleexist = false
                  i += 1
                  rs.each_hash do |row|
                    if cs[:title].downcase.include? encode.encode_title(row['shorttitle']).downcase
                      titleexist = true
                      break
                    end
                  end

                  # Get the titles that do not map between app site and expected
                  pending_string << " => #{cs[:title]} - Posistion: #{i}  ||  " unless titleexist
                end
                pending pending_string
              end
            end
          end # end main context
        end # end storefronts
      end # end locales
    end # end feature
  end # end def
end
