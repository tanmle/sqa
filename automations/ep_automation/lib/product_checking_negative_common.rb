require 'mysql'
require 'selenium-webdriver'
require 'capybara/rspec'
require 'rspec/expectations'
require 'rspec'
require 'lfcontentutilities.rb'
require 'const'
require 'json'

def get_skill_negative_parameters(locale, storefront, skill)
  if skill.include?('&')
    temp_skill = skill.split('&').map(&:strip)
  else
    temp_skill = "#{skill}&#{skill}".split('&').map(&:strip)
  end
  link = skill
  url = TestInfor.get_storefront_url locale, storefront
  case storefront
  when StorefrontConst::CONST_STOREFRONT_LP
    if skill == 'Creativity & Life Skills'
      rs_query = "select * from #{TableName::CONST_TITLE_TABLE} where golivedate = '#{TestInfor::CONST_RELEASE}' and (!(skill like '%#{temp_skill[0]}%' or skill like '%#{temp_skill[1]}%' or skill like '%Language Learning%' or skill like '%Logic & Problem Solving%' or skill like '%Personal & Social Skills%') or (#{locale} = '') or (lpu = '' and lp2 = '' and lp1 = '')) ;"
    else
      rs_query = "select * from #{TableName::CONST_TITLE_TABLE} where golivedate = '#{TestInfor::CONST_RELEASE}' and (!(skill like '%#{temp_skill[0]}%' or skill like '%#{temp_skill[1]}%') or (#{locale} = '') or (lpu = '' and lp2 = '' and lp1 = '')) ;"
    end
  when StorefrontConst::CONST_STOREFRONT_LE
    if skill == 'Creativity & Life Skills'
      rs_query = "select * from #{TableName::CONST_TITLE_TABLE} where golivedate = '#{TestInfor::CONST_RELEASE}' and (!(skill like '%#{temp_skill[0]}%' or skill like '%#{temp_skill[1]}%' or skill like '%Language Learning%' or skill like '%Logic & Problem Solving%' or skill like '%Personal & Social Skills%') or (#{locale} = '') or (lgs = '' and lex = '')) ;"
    else
      rs_query = "select * from #{TableName::CONST_TITLE_TABLE} where golivedate = '#{TestInfor::CONST_RELEASE}' and (!(skill like '%#{temp_skill[0]}%' or skill like '%#{temp_skill[1]}%') or (#{locale} = '') or (lgs = '' and lex = '')) ;"
    end
  when StorefrontConst::CONST_STOREFRONT_LR
    if skill == 'Creativity & Life Skills'
      rs_query = "select * from #{TableName::CONST_TITLE_TABLE} where golivedate = '#{TestInfor::CONST_RELEASE}' and (!(skill like '%#{temp_skill[0]}%' or skill like '%#{temp_skill[1]}%' or skill like '%Language Learning%' or skill like '%Logic & Problem Solving%' or skill like '%Personal & Social Skills%') or (#{locale} = '') or (lpr = '')) ;"
    else
      rs_query = "select * from #{TableName::CONST_TITLE_TABLE} where golivedate = '#{TestInfor::CONST_RELEASE}' and (!(skill like '%#{temp_skill[0]}%' or skill like '%#{temp_skill[1]}%') or (#{locale} = '') or (lpr = '')) ;"
    end
  end
  { link: link, url: url, rs_query: rs_query }
end

def get_character_negative_parameters(locale, storefront, character)
  link = character
  url = TestInfor.get_storefront_url locale, storefront
  case storefront
  when StorefrontConst::CONST_STOREFRONT_LP
    rs_query = "select sku, shorttitle, concat(',',lf_char,',') as tmplfchar from #{TableName::CONST_TITLE_TABLE} where (#{locale} = '' or storevisible = 1 or (lpu = '' and lp2 = '' and lp1 = '') or concat(',',lf_char,',') not like '%,#{DataConvert.character_string(character)},%');"
  when StorefrontConst::CONST_STOREFRONT_LE
    rs_query = "select sku, shorttitle, concat(',',lf_char,',') as tmplfchar from #{TableName::CONST_TITLE_TABLE} where (#{locale} = '' or storevisible = 1 or (lgs = '' and lex = '') or concat(',',lf_char,',') not like '%,#{DataConvert.character_string(character)},%');"
  when StorefrontConst::CONST_STOREFRONT_LR
    rs_query = "select sku, shorttitle, concat(',',lf_char,',') as tmplfchar from #{TableName::CONST_TITLE_TABLE} where (#{locale} = '' or storevisible = 1 or lpr = '' or concat(',',lf_char,',') not like '%,#{DataConvert.character_string(character)},%');"
  end
  { link: link, url: url, rs_query: rs_query }
end

def get_category_negative_parameters(locale, storefront, category)
  link = category
  url = TestInfor.get_storefront_url locale, storefront
  case storefront
  when StorefrontConst::CONST_STOREFRONT_LP
    rs_query = "select * from #{TableName::CONST_TITLE_TABLE} where golivedate = '#{TestInfor::CONST_RELEASE}' and (category not in ('#{category}') or (#{locale} = '') or (lpu = '' and lp2 = '' and lp1 = '')) ;"
  when StorefrontConst::CONST_STOREFRONT_LE
    rs_query = "select * from #{TableName::CONST_TITLE_TABLE} where golivedate = '#{TestInfor::CONST_RELEASE}' and (category not in ('#{category}') or (#{locale} = '') or (lgs = '' and lex = '')) ;"
  when StorefrontConst::CONST_STOREFRONT_LR
    rs_query = "select * from #{TableName::CONST_TITLE_TABLE} where golivedate = '#{TestInfor::CONST_RELEASE}' and (category not in ('#{category}') or (#{locale} = '') or (lpr = '')) ;"
  end
  { link: link, url: url, rs_query: rs_query }
end

def get_category_negative_parameters_fr(locale, storefront, category)
  link = category
  url = TestInfor.get_storefront_url_fr locale, storefront
  case storefront
  when StorefrontConst::CONST_STOREFRONT_LP_FR
    rs_query = "select * from #{TableName::CONST_TITLE_FR} where golivedate = '#{TestInfor::CONST_RELEASE}' and (category not in ('#{category}') or (#{locale} = '') or (lpu = '' and lp2 = '' and lp1 = '')) ;"
  when StorefrontConst::CONST_STOREFRONT_LE_FR
    rs_query = "select * from #{TableName::CONST_TITLE_FR} where golivedate = '#{TestInfor::CONST_RELEASE}' and (category not in ('#{category}') or (#{locale} = '') or (lgs = '' and lex = '')) ;"
  end
  { link: link, url: url, rs_query: rs_query }
end

def get_skill_negative_parameters_fr(locale, storefront, skill)
  link = skill
  url = TestInfor.get_storefront_url_fr locale, storefront
  case storefront
  when StorefrontConst::CONST_STOREFRONT_LP
    rs_query = "select * from #{TableName::CONST_TITLE_FR} where golivedate = '#{TestInfor::CONST_RELEASE}' and (skill not in ('#{skill}') or (#{locale} = '') or (lpu = '' and lp2 = '' and lp1 = '')) ;"
  when StorefrontConst::CONST_STOREFRONT_LE
    rs_query = "select * from #{TableName::CONST_TITLE_FR} where golivedate = '#{TestInfor::CONST_RELEASE}' and (skill not in ('#{skill}') or (#{locale} = '') or (lgs = '' and lex = '')) ;"
  end
  { link: link, url: url, rs_query: rs_query }
end

def get_params(td, type, english = true)
  locale = td['locale']
  storefront = DataConvert.storefront td['storefront'], english
  if english
    case type
    when TestProductType::CONST_CATEGORY
      params = get_category_negative_parameters locale, storefront, td['category']
    when TestProductType::CONST_SKILL
      params = get_skill_negative_parameters locale, storefront, td['skill']
    when TestProductType::CONST_CHARACTER
      params = get_character_negative_parameters locale, storefront, td['char_string']
    end
  else
    case type
    when TestProductType::CONST_CATEGORY
      params = get_category_negative_parameters_fr locale, storefront, td['category']
    when TestProductType::CONST_SKILL
      params = get_skill_negative_parameters_fr locale, storefront, td['skill']
    end
  end
  params.merge locale: locale, storefront: storefront
end

# This class is to process and run test cases
# Date created: 12/20/2013 Updated: 12/15/2014
class <<self
  def verify_product_information_negative(testdriver, type, english = true)
    web_utilities = WebContentUtilities.new
    feature "#{type} negative checking EP content", js: true do
      testdriver.each_hash do |td|
        params = get_params td, type, english
        html_doc = nil
        locale = params[:locale]
        storefront = params[:storefront]
        link = params[:link]
        url = params[:url]
        rs_query = params[:rs_query]

        # Getting expected data in mysql
        con = Mysql.new MySQLConst::CONST_SERVER, MySQLConst::CONST_USERNAME, MySQLConst::CONST_PASSOWRD, MySQLConst::CONST_DATABASE, MySQLConst::CONST_PORT
        rs_title = con.query rs_query
        con.close if con
        total = rs_title.count
        context "#{locale.upcase} - #{storefront.upcase} - #{link} #{type} negative checking - Total SKUs: #{total}", js: true do
          if total == 0
            it 'There is no app available.' do
            end
          else
            before :all do
              # go to storefront
              web_utilities.go_to url

              # click show more of character section
              web_utilities.click_showmore if type == TestProductType::CONST_CHARACTER

              # clicking on left nav link
              web_utilities.go_category link
              html_doc = web_utilities.to_html_document(web_utilities.get_page_content('div#categories'))
            end
          end

          id = 0 # Count SKU number
          rs_title.data_seek(0)
          rs_title.each_hash do |r_title|
            # Verify all titles that has "should not available " on locale should not exist on all character page and consecutive locale
            scenario "#{id += 1} - SKU = #{r_title['sku'].strip} - #{r_title['shorttitle']}", js: true do
              sku_exist = html_doc.css("div[class='productDetail'] > a[href*='#{r_title['sku'].strip}']")
              sku_exist.to_s.should eq('')
            end
          end # end rs_skill
        end # end if total != 0
      end # end context
    end # end feature
  end
end
