require 'yaml'
require 'nokogiri'

class TestInfor
  xml_content = File.read $LOAD_PATH.detect { |path| path.index('data.xml') } || 'TEMPORARY DATA FILE IS MISSING. PLEASE RECHECK!'
  $doc = Nokogiri::XML(xml_content)

  # In order to run script on product environment, set: prod
  # qa environment: qa
  CONST_ENV = $doc.xpath('//information/env').text

  # Release date
  CONST_RELEASE = $doc.xpath('//information/releasedate').text

  # return url contains locale, storefront
  def self.get_storefront_url(locale, storefront)
    stf = nil
    case storefront
    when StorefrontConst::CONST_STOREFRONT_LP
      stf = 'LeapPadExplorer'
    when StorefrontConst::CONST_STOREFRONT_LE
      stf = 'LeapsterExplorer'
    when StorefrontConst::CONST_STOREFRONT_LR
      stf = 'LeapReader'
    end

    "http://#{locale}.#{TestInfor::CONST_ENV.gsub('prod', '').gsub('qa', 'qa-')}appcenter.leapfrog.com/storefront/home.ep?recalculatedDomain=1&ignoreDeepLink=1&deviceMode=#{stf}&countrySwitch=1"
  end

  # return url contains locale, storefront
  def self.get_storefront_url_fr(locale, storefront)
    stf = nil
    case storefront
    when StorefrontConst::CONST_STOREFRONT_LP_FR
      stf = 'LeapPadExplorer'
    when StorefrontConst::CONST_STOREFRONT_LE_FR
      stf = 'LeapsterExplorer'
    end

    "https://#{locale}.#{TestInfor::CONST_ENV.gsub('prod', '').gsub('qa', 'qa-')}appcenter.leapfrog.com/storefront/home.ep?deviceMode=#{stf}"
  end
end

class TestProductType
  CONST_CATEGORY = 'Category'
  CONST_SKILL = 'Skill'
  CONST_AGE = 'Age'
  CONST_CHARACTER = 'Character'
end

class MySQLConst
  # get information from config/database.yml file
  config = YAML::load_file('config/database.yml')['development']

  CONST_SERVER = config['host']
  CONST_USERNAME = config['username']
  CONST_PASSOWRD = config['password']
  CONST_DATABASE = config['database']
  CONST_PORT = config['port']
end

# The following constant variables drive the test run, please set const to nil to ignore running that locale.
class LocalesConst
  CONST_US = 'us'
  CONST_UK = 'uk'
  CONST_AU = 'au'
  CONST_IE = 'ie'
  CONST_CA = 'ca'
  CONST_ROW = 'row'
  CONST_FR_FR = 'fr_fr'
  CONST_FR_CA = 'fr_ca'
  CONST_FR_ROW = 'fr_row'
end

# The following constant variables drive the test run, please set const to nil to ignore running that storefront.
class StorefrontConst
  CONST_STOREFRONT_LP = 'LeapPad Apps'
  CONST_STOREFRONT_LE = 'Leapster Explorer Apps'
  CONST_STOREFRONT_LR = 'LeapReader Apps'
  CONST_STOREFRONT_LP_FR = 'Apps LeapPad'
  CONST_STOREFRONT_LE_FR = 'Apps Leapster Explorer'
end

class TestDriver
  # Get locales, storefronts for checking
  CONST_LOCALES = [LocalesConst::CONST_US, LocalesConst::CONST_UK, LocalesConst::CONST_CA, LocalesConst::CONST_IE, LocalesConst::CONST_AU, LocalesConst::CONST_ROW]
  CONST_STOREFRONTS = [StorefrontConst::CONST_STOREFRONT_LP, StorefrontConst::CONST_STOREFRONT_LE, StorefrontConst::CONST_STOREFRONT_LR]
  CONST_LOCALES_FR = [LocalesConst::CONST_FR_FR, LocalesConst::CONST_FR_CA, LocalesConst::CONST_FR_ROW]
  CONST_STOREFRONTS_FR = [StorefrontConst::CONST_STOREFRONT_LP_FR, StorefrontConst::CONST_STOREFRONT_LE_FR]
end

# This class define SQL to query category, skill, age or character
class SQLTestDriverConst
  # Get categories for checking
  CONST_SQL_CATEGORY = "select * from ep_category where locale in ('us','ca','uk','ie','au','row') ORDER BY locale DESC;"

  # Get skills for checking
  CONST_SQL_SKILL = "select * from ep_skills where locale in ('us','ca','uk','ie','au','row');"

  # Get ages for checking
  CONST_SQL_AGE = "select * from ep_ages where locale in ('us','ca','uk','ie','au','row');"

  # Get characters for checking
  CONST_SQL_CHARACTER = "select * from ep_characters where locale in ('us','ca','uk','ie','au','row');"

  # Get categories for checking on French locales
  CONST_SQL_CATEGORY_FR = "select * from ep_category where locale in ('fr_fr','fr_row','fr_ca');"

  # Get skills for checking on French locales
  CONST_SQL_SKILL_FR = "select * from ep_skills where locale in ('fr_fr','fr_row','fr_ca');"

  # Get ages for checking on French locales
  CONST_SQL_AGE_FR = "select * from ep_ages where locale in ('fr_fr','fr_ca','fr_ca');"
end

class TableName
  CONST_TABLE_NAME = 'ep_temp' # this is used by the XML tool
  CONST_TITLE_TABLE = 'ep_titles'
  CONST_TITLE_FEAT = 'ep_titles_feat'
  CONST_TITLE_FR = 'ep_titles_fr'
  CONST_TITLE_CHR = 'ep_temp'  # need to change this for final version - same structure as temp table
end

class XMLFile
  CONST_XML_FILENAME = './soap.xml'
end

class Account
  CONST_USERNAME = 'ltrc_recommendation@leapfrog.test'
  CONST_PASSWORD = '123456'
end

class CSCode
  CONST_CSCODE = '4601-2644-8831-7915'
end

class TimeOut
  # for page load
  CONST_READTIMEOUT = 150
  READTIMEOUT_CONST = 150

  # for control: default 2s
  CONST_WAIT_CONTROL = 2
  WAIT_CONTROL_CONST = 2

  # for controls: AJAX
  CONST_WAIT_AJAX_CONTROL = 60
end
