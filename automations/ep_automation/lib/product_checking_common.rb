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

def get_category_parameters(locale, storefront, category)
  link = category
  url = TestInfor.get_storefront_url locale, storefront
  case storefront
  when StorefrontConst::CONST_STOREFRONT_LP
    rs_query = "select * from #{TableName::CONST_TITLE_TABLE} where golivedate = '#{TestInfor::CONST_RELEASE}' and (#{locale} = 'X' and category like '#{category.gsub('New!', '%')}' and (lpu = 'X' or lp2 = 'X' or lp1 = 'X')) ;"
  when StorefrontConst::CONST_STOREFRONT_LE
    rs_query = "select * from #{TableName::CONST_TITLE_TABLE} where golivedate = '#{TestInfor::CONST_RELEASE}' and (#{locale} = 'X' and category like '#{category.gsub('New!', '%')}' and (lgs = 'X' or lex = 'X')) ;"
  when StorefrontConst::CONST_STOREFRONT_LR
    rs_query = "select * from #{TableName::CONST_TITLE_TABLE} where golivedate = '#{TestInfor::CONST_RELEASE}' and (#{locale} = 'X' and category like '#{category.gsub('New!', '%')}' and lpr = 'X') ;"
  end
  { link: link, url: url, rs_query: rs_query }
end

def get_skill_parameters(locale, storefront, skill)
  skill_temp = []
  if skill.include?('&')
    skill_temp = skill.split('&').map(&:strip)
  else
    skill_temp = "#{skill}&#{skill}".split('&').map(&:strip)
  end

  link = skill
  url = TestInfor.get_storefront_url locale, storefront
  case storefront
  when StorefrontConst::CONST_STOREFRONT_LP
    if skill == 'Creativity & Life Skills'
      rs_query = "select * from #{TableName::CONST_TITLE_TABLE} where golivedate = '#{TestInfor::CONST_RELEASE}' and (#{locale} = 'X' and (skill like '%#{skill_temp[0]}%' or skill like '%#{skill_temp[1]}%' or skill like '%Language Learning%' or skill like '%Logic & Problem Solving%' or skill like '%Personal & Social Skills%') and (lpu = 'X' or lp2 = 'X' or lp1 = 'X')) ;"
    else
      rs_query = "select * from #{TableName::CONST_TITLE_TABLE} where golivedate = '#{TestInfor::CONST_RELEASE}' and (#{locale} = 'X' and (skill like '%#{skill_temp[0]}%' or skill like '%#{skill_temp[1]}%') and (lpu = 'X' or lp2 = 'X' or lp1 = 'X')) ;"
    end
  when StorefrontConst::CONST_STOREFRONT_LE
    if skill == 'Creativity & Life Skills'
      rs_query = "select * from #{TableName::CONST_TITLE_TABLE} where golivedate = '#{TestInfor::CONST_RELEASE}' and (#{locale} = 'X' and (skill like '%#{skill_temp[0]}%' or skill like '%#{skill_temp[1]}%' or skill like '%Language Learning%' or skill like '%Logic & Problem Solving%' or skill like '%Personal & Social Skills%') and (lgs = 'X' or lex = 'X')) ;"
    else
      rs_query = "select * from #{TableName::CONST_TITLE_TABLE} where golivedate = '#{TestInfor::CONST_RELEASE}' and (#{locale} = 'X' and (skill like '%#{skill_temp[0]}%' or skill like '%#{skill_temp[1]}%')  and (lgs = 'X' or lex = 'X')) ;"
    end
  when StorefrontConst::CONST_STOREFRONT_LR
    if skill == 'Creativity & Life Skills'
      rs_query = "select * from #{TableName::CONST_TITLE_TABLE} where golivedate = '#{TestInfor::CONST_RELEASE}' and (#{locale} = 'X' and (skill like '%#{skill_temp[0]}%' or skill like '%#{skill_temp[1]}%' or skill like '%Language Learning%' or skill like '%Logic & Problem Solving%' or skill like '%Personal & Social Skills%') and lpr = 'X') ;"
    else
      rs_query = "select * from #{TableName::CONST_TITLE_TABLE} where golivedate = '#{TestInfor::CONST_RELEASE}' and (#{locale} = 'X' and (skill like '%#{skill_temp[0]}%' or skill like '%#{skill_temp[1]}%')  and lpr = 'X') ;"
    end
  end
  { link: link, url: url, rs_query: rs_query }
end

def get_age_parameters(locale, storefront, age)
  link = age
  url = TestInfor.get_storefront_url locale, storefront
  case storefront
  when StorefrontConst::CONST_STOREFRONT_LP
    rs_query = "select * from #{TableName::CONST_TITLE_TABLE} where golivedate = '#{TestInfor::CONST_RELEASE}' and (#{locale} = 'X' and agefrommonths/12 <= '#{age[0, 1]}' and agetomonths/12 >= '#{age[0, 1]}' and (lpu = 'X' or lp2 = 'X' or lp1 = 'X')) ;"
  when StorefrontConst::CONST_STOREFRONT_LE
    rs_query = "select * from #{TableName::CONST_TITLE_TABLE} where golivedate = '#{TestInfor::CONST_RELEASE}' and (#{locale} = 'X' and agefrommonths/12 <= '#{age[0, 1]}' and agetomonths/12 >= '#{age[0, 1]}'  and (lgs = 'X' or lex = 'X')) ;"
  when StorefrontConst::CONST_STOREFRONT_LR
    rs_query = "select * from #{TableName::CONST_TITLE_TABLE} where golivedate = '#{TestInfor::CONST_RELEASE}' and (#{locale} = 'X' and agefrommonths/12 <= '#{age[0, 1]}' and agetomonths/12 >= '#{age[0, 1]}'  and lpr = 'X') ;"
  end
  { link: link, url: url, rs_query: rs_query }
end

def get_character_parameters(locale, storefront, character)
  link = character
  url = TestInfor.get_storefront_url locale, storefront
  case storefront
  when StorefrontConst::CONST_STOREFRONT_LP
    rs_query = "select *, concat(',',lf_char,',') as tmplfchar from #{TableName::CONST_TITLE_TABLE} where #{locale} = 'X' and storevisible = 0 and (lpu = 'X' or lp2 = 'X' or lp1 = 'X') group by sku having tmplfchar like '%,#{DataConvert.character_string(character)},%' ;"
  when StorefrontConst::CONST_STOREFRONT_LE
    rs_query = "select *, concat(',',lf_char,',') as tmplfchar from #{TableName::CONST_TITLE_TABLE} where #{locale} = 'X' and storevisible = 0 and (lgs = 'X' or lex = 'X') group by sku having tmplfchar like '%,#{DataConvert.character_string(character)},%' ;"
  when StorefrontConst::CONST_STOREFRONT_LR
    rs_query = "select *, concat(',',lf_char,',') as tmplfchar from #{TableName::CONST_TITLE_TABLE} where #{locale} = 'X' and storevisible = 0 and lpr = 'X' group by sku having tmplfchar like '%,#{DataConvert.character_string(character)},%' ;"
  end
  { link: link, url: url, rs_query: rs_query }
end

def get_pt_query(locale)
  case locale
  when 'fr_row'
    pt_query = "select * from ep_pricetier where locale = '#{locale[3, 3]}';"
  when 'fr_ca'
    pt_query = "select * from ep_pricetier where locale = '#{locale[3, 2]}';"
  else
    pt_query = "select * from ep_pricetier where locale = '#{locale}';"
  end
  pt_query
end

def get_category_parameters_fr(locale, storefront, category)
  link = category
  url = TestInfor.get_storefront_url_fr locale, storefront
  case storefront
  when StorefrontConst::CONST_STOREFRONT_LP
    rs_query = "select * from #{TableName::CONST_TITLE_FR} where golivedate = '#{TestInfor::CONST_RELEASE}' and (#{locale} = 'X' and category = '#{DataConvert.convert_french_to_english('contenttype', category)}' and (lpu = 'X' or lp2 = 'X' or lp1 = 'X')) ;"
  when StorefrontConst::CONST_STOREFRONT_LE
    rs_query = "select * from #{TableName::CONST_TITLE_FR} where golivedate = '#{TestInfor::CONST_RELEASE}' and (#{locale} = 'X' and category = '#{DataConvert.convert_french_to_english('contenttype', category)}' and (lgs = 'X' or lex = 'X')) ;"
  end
  { link: link, url: url, rs_query: rs_query }
end

def get_skill_parameters_fr(locale, storefront, skill)
  link = skill
  url = TestInfor.get_storefront_url_fr locale, storefront
  case storefront
  when StorefrontConst::CONST_STOREFRONT_LP
    rs_query = "select * from #{TableName::CONST_TITLE_FR} where golivedate = '#{TestInfor::CONST_RELEASE}' and (skill = '#{DataConvert.convert_french_to_english('skill', skill)}' and #{locale} = 'X' and (lpu = 'X' or lp2 = 'X' or lp1 = 'X')) ;"
  when StorefrontConst::CONST_STOREFRONT_LE
    rs_query = "select * from #{TableName::CONST_TITLE_FR} where golivedate = '#{TestInfor::CONST_RELEASE}' and (#{locale} = 'X' and skill = '#{DataConvert.convert_french_to_english('skill', skill)}'  and (lgs = 'X' or lex = 'X')) ;"
  end
  { link: link, url: url, rs_query: rs_query }
end

def get_age_parameters_fr(locale, storefront, age)
  link = age
  url = TestInfor.get_storefront_url_fr locale, storefront
  case storefront
  when StorefrontConst::CONST_STOREFRONT_LP_FR
    rs_query = "select * from #{TableName::CONST_TITLE_FR} where golivedate = '#{TestInfor::CONST_RELEASE}' and (#{locale} = 'X' and agefrommonths/12 <= '#{age[0, 1]}' and agetomonths/12 >= '#{age[0, 1]}' and (lpu = 'X' or lp2 = 'X' or lp1 = 'X')) ;"
  when StorefrontConst::CONST_STOREFRONT_LE_FR
    rs_query = "select * from #{TableName::CONST_TITLE_FR} where golivedate = '#{TestInfor::CONST_RELEASE}' and (#{locale} = 'X' and agefrommonths/12 <= '#{age[0, 1]}' and agetomonths/12 >= '#{age[0, 1]}'  and (lgs = 'X' or lex = 'X')) ;"
  end
  { link: link, url: url, rs_query: rs_query }
end

def get_params(td, type, english = true)
  locale = td['locale']
  storefront = DataConvert.storefront td['storefront'], english
  if english
    case type
    when TestProductType::CONST_CATEGORY
      params = get_category_parameters locale, storefront, td['category']
    when TestProductType::CONST_SKILL
      params = get_skill_parameters locale, storefront, td['skill']
    when TestProductType::CONST_CHARACTER
      params = get_character_parameters locale, storefront, td['char_string']
    when TestProductType::CONST_AGE
      params = get_age_parameters locale, storefront, td['agestring']
    end
  else
    case type
    when TestProductType::CONST_CATEGORY
      params = get_category_parameters_fr locale, storefront, td['category']
    when TestProductType::CONST_SKILL
      params = get_skill_parameters_fr locale, storefront, td['skill']
    when TestProductType::CONST_AGE
      params = get_age_parameters_fr locale, storefront, td['agestring']
    end
  end
  params.merge pt_query: get_pt_query(locale), locale: locale, storefront: storefront
end

# Created: 12/20/2013, Updated: 12/12/2014
class << self
  def verify_product_information(testdriver, type, english = true)
    web_utilities = WebContentUtilities.new
    encode = RspecEncode.new
    feature "#{type} checking EP content", js: true do
      testdriver.each_hash do |td|
        params = get_params td, type, english
        html_doc = nil
        locale = params[:locale]
        storefront = params[:storefront]
        link = params[:link]
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

        context "#{locale.upcase} - #{storefront.upcase} - #{link} #{type} checking - Env: #{TestInfor::CONST_ENV.upcase} - Totals SKUs: #{total}", js: true do # Checking data for New! category
          if total == 0
            it 'There is no app available.' do
            end
          else
            before :all do
              web_utilities.go_to url
              web_utilities.click_showmore if type == TestProductType::CONST_CHARACTER

              # Clicking on left nav link
              web_utilities.go_category link
              html_doc = web_utilities.to_html_document(web_utilities.get_page_content('div#categories'))
            end

            id = 0 # Title number
            rs.data_seek(0)
            rs.each_hash do |row|
              context "#{id += 1} - SKU = #{row['sku'].strip} - #{row['shorttitle']}", js: true do
                href = nil
                title = nil
                curriculum = nil
                age = nil
                price = nil
                inpage = false
                if english
                  age_string = Title.new.calculateagestring row
                else
                  age_string = Title.new.calculateagestring_fr row
                end
                price_string = Title.new.calculateprice row, pt

                scenario 'Get product information', js: true do
                  html_doc.css("div[class='productDetail']").each do |product_element|
                    pd = product_element.at_css("a[href*='#{row['sku'].strip}']")
                    next if pd.nil?
                    product = pd.parent
                    title = product.css('a.title').text
                    href = product.css('a.title @href').to_s
                    curriculum = product_element.css('span.curriculum').text
                    age = product.css('span.age').text
                    if product.css('p.price > span.regularprice').to_s != ''
                      price = product.css('p.price > span.regularprice').text
                    else
                      price = product.css('p.price > span').text
                    end
                  end
                end

                scenario 'Checking sku in page', js: true do
                  inpage = true if !href.nil? && href.include?(row['sku'].strip)
                  if inpage == true
                    inpage.should equal true
                  else
                    raise Exception.new("Expected: This title with sku = #{row['sku'].strip} is existed\nGot: This title is missing")
                  end
                end

                scenario "Checking title \"#{row['shorttitle']}\"", js: true do
                  if inpage == true
                    expect(encode.encode_title(title).strip).to eq(encode.encode_title(row['shorttitle']).strip)
                  else
                    pending("This title with sku = '#{row['sku'].strip}' is missing")
                  end
                end

                scenario "Checking price \"#{price_string}\"", js: true do
                  if inpage == true
                    expect(price).to eq(encode.encode_price(price_string))
                  else
                    pending("This title with sku = '#{row['sku'].strip}' is missing")
                  end
                end

                scenario "Checking age \"#{age_string}\"", js: true do
                  if inpage == true
                    expect(age).to eq(age_string)
                  else
                    pending("This title with sku = '#{row['sku'].strip}' is missing")
                  end
                end

                e_curriculum = (english) ? row['curriculum'] : DataConvert.convert_english_to_french('curriculum', row['curriculum'])
                scenario "Checking curriculum \"#{e_curriculum}\"", js: true do
                  if inpage
                    expect(curriculum).to eq(e_curriculum)
                  else
                    pending("This title with sku = '#{row['sku'].strip}' is missing")
                  end
                end
              end # end context
            end # end row.each
          end # end main context
        end # end if total != 0
      end # end test driver loop
    end # end feature/top describe
  end # end method
end # end class
