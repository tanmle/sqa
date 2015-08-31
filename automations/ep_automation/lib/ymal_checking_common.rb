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

def get_ymal_parameters(locale, storefront)
  url = TestInfor.get_storefront_url locale, storefront
  case storefront
  when StorefrontConst::CONST_STOREFRONT_LP
    rs_query = "select * from #{TableName::CONST_TITLE_TABLE} where golivedate = '#{TestInfor::CONST_RELEASE}' and (#{locale} = 'X' and (lpu = 'X' or lp2 = 'X' or lp1 = 'X')) ;"
  when StorefrontConst::CONST_STOREFRONT_LE
    rs_query = "select * from #{TableName::CONST_TITLE_TABLE} where golivedate = '#{TestInfor::CONST_RELEASE}' and (#{locale} = 'X' and (lgs = 'X' or lex = 'X'));"
  when StorefrontConst::CONST_STOREFRONT_LR
    rs_query = "select * from #{TableName::CONST_TITLE_TABLE} where golivedate = '#{TestInfor::CONST_RELEASE}' and (#{locale} = 'X' and lpr = 'X') ;"
  end
  { url: url, rs_query: rs_query }
end

def get_ymal_in_database(ymal_sku_arr, locale, storefront)
  con = Mysql.new MySQLConst::CONST_SERVER, MySQLConst::CONST_USERNAME, MySQLConst::CONST_PASSOWRD, MySQLConst::CONST_DATABASE, MySQLConst::CONST_PORT
  ymal_arr = []
  ymal_sku_arr.each do |sku|
    case storefront
    when StorefrontConst::CONST_STOREFRONT_LP
      titles_list = con.query "select sku, shorttitle, platformcompatibility, us, ca, uk, ie, au, row from #{TableName::CONST_TITLE_TABLE} where sku = '#{sku}' and (#{locale} = 'X' and (lpu = 'X' or lp2 = 'X' or lp1 = 'X')) ;"
    when StorefrontConst::CONST_STOREFRONT_LE
      titles_list = con.query "select sku, shorttitle, platformcompatibility, us, ca, uk, ie, au, row from #{TableName::CONST_TITLE_TABLE} where sku = '#{sku}' and (#{locale} = 'X' and (lgs = 'X' or lex = 'X'));"
    when StorefrontConst::CONST_STOREFRONT_LR
      titles_list = con.query "select sku, shorttitle, platformcompatibility, us, ca, uk, ie, au, row from #{TableName::CONST_TITLE_TABLE} where sku = '#{sku}' and (#{locale} = 'X' and lpr = 'X') ;"
    else
      titles_list = nil
    end

    titles_list.each_hash do |title|
      shortname = title['shorttitle']
      platform = title['platformcompatibility']
      us = title['us']
      ca = title['ca']
      uk = title['uk']
      ie = title['ie']
      au = title['au']
      row = title['row']
      ymal_arr.push(sku: sku, title: shortname, platform: platform, us: us, ca: ca, uk: uk, ie: ie, au: au, row: row)
    end
  end
  con.close if con
  ymal_arr
end

#
# Return true if e_arr and a_arr there is at least one same element
#
def two_platforms_compare?(e_platform, a_platform)
  e_arr = e_platform.split(',')
  a_arr = a_platform.split(',')
  (e_arr & a_arr).empty? ? false : true
end

def support_locale?(ymal_title_hash, locale)
  support =
    case locale.upcase
    when 'US' then
      ymal_title_hash[:us]
    when 'CA' then
      ymal_title_hash[:ca]
    when 'UK' then
      ymal_title_hash[:uk]
    when 'IE' then
      ymal_title_hash[:ie]
    when 'AU' then
      ymal_title_hash[:au]
    else
      ymal_title_hash[:row]
    end
  support.to_s == 'X'
end

class << self
  def verify_ymal(locales, storefronts)
    encode = RspecEncode.new
    web_utilities = WebContentUtilities.new
    feature 'YMAL checking ep content automation', js: true do
      locales.each do |locale|
        storefronts.each do |storefront|
          params = get_ymal_parameters locale, storefront
          url = params[:url]
          rs_query = params[:rs_query]
          id = 0
          sku = nil

          # Getting expected data in mysql
          con = Mysql.new MySQLConst::CONST_SERVER, MySQLConst::CONST_USERNAME, MySQLConst::CONST_PASSOWRD, MySQLConst::CONST_DATABASE, MySQLConst::CONST_PORT
          rs = con.query rs_query
          con.close if con
          total = rs.count

          context "#{locale} - #{storefront} checking - #{TestInfor::CONST_ENV} - Total SKUs: #{total}", js: true do
            if total == 0
              it 'There is no app available.' do
              end
            else
              before :all do
                # Go to storefront
                web_utilities.go_to url
              end

              rs.data_seek(0)
              rs.each_hash do |row|
                context "#{id += 1} - SKU = #{row['sku']} - #{row['shorttitle']}", js: true do
                  # Expected value variable
                  title_platform = row['platformcompatibility']
                  title_ymal = row['ymal'].nil? ? [] : row['ymal'].split(',')

                  # get information of all ymal items
                  e_ymal_info = get_ymal_in_database title_ymal, locale, storefront
                  e_ymal = nil

                  # Actual value variable
                  a_ymal_info = []
                  a_ymal = nil
                  has_title = false

                  # Process product description in page
                  scenario 'Search by SKU', js: true do
                    web_utilities.enter_sku(row['sku'].strip)
                    if page.has_xpath?("//div[@class='productDetail']/a[contains(@href,'#{row['sku'].strip}')]", wait: 0)
                      has_title = true
                    else
                      pending 'This title is missing'
                    end
                  end

                  scenario 'Go to PDP page', js: true do
                    if has_title == true
                      web_utilities.go_pdp(row['sku'])
                    else
                      pending("This title with sku = '#{row['sku']}' is missing")
                    end
                  end

                  scenario 'Get YMAL information on PDP page', js: true do
                    if has_title
                      page.all('div.productDetail').each do |el|
                        within el do
                          sku = find('a.title')[:href][-16..-6]
                          title = find('a.title').text
                          link = find('a.title')[:href]
                          a_ymal_info.push(sku: sku, title: title, link: link)
                        end
                      end
                    else
                      pending 'Missing title'
                    end
                  end

                  scenario "Verify the number of app in YMAL section is #{e_ymal_info.count}", js: true do
                    expect(a_ymal_info.count).to eq(e_ymal_info.count)
                  end

                  context 'Check YMAL information (SKU, title, link, locale,...) on PDP page' do
                    e_ymal_info.each do |e|
                      context "SKU = '#{e[:sku]}' - Title = '#{e[:title]}'" do
                        before :all do
                          e_ymal = e_ymal_info.find { |y| y[:sku].include?(e[:sku]) }
                          a_ymal = a_ymal_info.find { |y| y[:sku].include?(e[:sku]) }
                        end

                        it 'Verify app displays in YMAL section' do
                          pending 'Missing item' if a_ymal.nil?
                        end

                        it 'Verify app title displays correctly' do
                          pending 'Missing item' if a_ymal.nil?
                          expect(encode.encode_title(a_ymal[:title])).to eq(encode.encode_title(e_ymal[:title]))
                        end

                        it 'Verify link shows correctly' do
                          pending 'Missing item' if a_ymal.nil?
                          expect(a_ymal[:link]).to include(e_ymal[:sku])
                        end

                        it 'Verify app is available for device' do
                          pending 'Missing item' if a_ymal.nil?
                          expect(two_platforms_compare?(title_platform, e_ymal[:platform])).to eq(true)
                        end

                        it 'Verify app is available in locale' do
                          pending 'Missing item' if a_ymal.nil?
                          expect(support_locale?(e_ymal, locale)).to eq(true)
                        end
                      end
                    end # end context check YMAL
                  end # end ymal title context
                end # end title context
              end # end row.each
            end # end if total != 0
          end # end main context
        end # end storefronts
      end # end locales
    end # end feature
  end
end
