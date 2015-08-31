xml_content = File.read $LOAD_PATH.detect { |path| path.index('data.xml') } || 'TEMPORARY DATA FILE IS MISSING. PLEASE RECHECK!'
$doc = Nokogiri::XML(xml_content)

class LFSOAP
  # Get env from data.xml
  CONST_ENV = $doc.search('//env').text # 'QA' or 'PROD'

  if CONST_ENV == 'QA'
    CONST_HOST = 'http://emqlcis.leapfrog.com'
    CONST_LINK_TO_MAKE_RELATION_WITH_VINDICIA_SYSTEM = 'https://uat2-www.leapfrog.com/en-us/store/profile/login.jsp'
    CONST_GAME_LOG_UPLOAD_LINK = 'http://qa-devicelog.leapfrog.com/upca/device_log_upload'
    CONST_DEVICE_LOG_UPLOAD_LINK = 'http://emqldlog01.leapfrog.com:8080/inmon/services'
    CONST_MYPALS_ENV = CONST_NARNIA_ENV = 'qa-'
  else
    CONST_HOST = 'http://evplcis.leapfrog.com'
    CONST_LINK_TO_MAKE_RELATION_WITH_VINDICIA_SYSTEM = 'https://www.leapfrog.com/en-us/store/profile/login.jsp'
    CONST_GAME_LOG_UPLOAD_LINK = 'http://devicelog.leapfrog.com/upca/device_log_upload'
    CONST_DEVICE_LOG_UPLOAD_LINK = 'http://evpldlog.leapfrog.com:8085/inmon/services'
    CONST_MYPALS_ENV = CONST_NARNIA_ENV = ''
  end

  CONST_PORT = '8080'
  CONST_INMON_PATH = 'inmon/services'
  CONST_URL = "#{CONST_HOST}:#{CONST_PORT}/#{CONST_INMON_PATH}"
end

# information of rest service
# relate to learning path rest service
class LFREST
  # WORKAROUND Using server instances for TC-QA - see SQAUTO-1179
  if LFSOAP::CONST_ENV == 'QA'
    CONST_ENDPOINT = 'http://emqlcis.leapfrog.com:8080/inmon/resting/v1' #'https://qa-services.leapfrog.com/rest/v1'
  else
    CONST_ENDPOINT = 'http://evplcis.leapfrog.com:8080/inmon/resting/v1' #'https://services.leapfrog.com/rest/v1'
  end
end

class KnownBug
  CONST_BUG_ID_33984 = 'Known bug: #33984'
end

class LFRESOURCES
  # ParentAPIs
  CONST_CREATE_PARENT = '/parent'
  CONST_FETCH_PARENT = CONST_UPDATE_PARENT = '/parent/%s'
  CONST_FETCH_CHILDREN = '/parent/%s/children'

  # ChildAPIs
  CONST_FETCH_CHILD = '/child/%s'
  CONST_FETCH_CHILD_GOALS = CONST_UPDATE_CHILD_GOALS = '/child/%s/goals'

  # MilestonesAPIs
  CONST_FETCH_MILESTONES = '/milestones'
  CONST_FETCH_MILESTONES_DETAIL = '/milestones/%s/goals'

  # GoalsAPIs
  CONST_FETCH_GOALS = '/milestones/%s/goals'

  # WeeklyContent
  CONST_FETCH_WEEKLY_CONTENT_BABY_CENTER = '/weeklyContent/%s'
  CONST_FETCH_WEEKLY_CONTENT_MILESTONES = '/weeklyContent/milestones/%s/%s'

  # Credential Management
  CONST_LOGIN = '/sso'
  CONST_RESET_PASSWORD = '/sso/password_reset'
  CONST_CHANGE_PASSWORD = '/sso/password'

  # Discussion Management
  CONST_FETCH_DISCUSSION = '/milestones/%s/discussions'

  # Setup Info
  CONST_FETCH_SETUP_INFO = '/setup'

  # Narnia
  CONST_UPDATE_NARNIA = '/devices/%s/users'
  CONST_RESET_NARNIA = '/devices/%s?releaseLic=true'
  CONST_OWNER_NARNIA = '/devices/%s/owner'

  # For Misc
  CONST_FETCH_DEVICE = '/devices/%s'
  CONST_DEVICE_INVENTORY = '/package/device-inventory?device-serial=%s'
  CONST_AUTHORIZE_INSTALLATION = '/package/authorize-installation?device-serial=%s&pkg-id=%s'
  CONST_PACKAGE_DEPENDENCIES = '/package/dependencies?%s'
  CONST_REPORT_INSTALLATION = '/package/report-installation'
  CONST_REMOVE_INSTALLATION = '/package/remove-installation'

  # For JUMP
  CONST_PETATHLON_COMPANION_APP_DATA = '/devices/%s/extras/petathlon'
  CONST_LEAPBAND_DATA = '/devices/%s/extras/leapband'
  CONST_BUCKETS = '/devices/%s/extras'

  CONST_DEVICES_ACTIVATION = '/devices/%s/activation'
end

class GLASGOW
  if LFSOAP::CONST_ENV == 'QA'
    CONST_EXPIRED_ACT_CODE = 'BYE4UD'
    CONST_GLASGOW_URL = 'https://qa-leaptv.leapfrog.com/register/logdevice.php'
    CONST_GLASGOW_ENV = 'qa-'
  else # Env = PROD
    CONST_EXPIRED_ACT_CODE = 'HD62P9'
    CONST_GLASGOW_URL = 'https://leaptv.leapfrog.com/register/logdevice.php'
    CONST_GLASGOW_ENV = ''
  end
end

class Misc
  CONST_PASSWORD = '123456'
  CONST_EMAIL_PREPEND = 'LFQA'
  CONST_EMAIL_APPEND = '@leapfrog.test'
  CONST_ENV = LFSOAP::CONST_ENV
  CONST_CALLER_ID = 'a023bc85-db5b-40b5-934c-28a72b4d9547'
  CONST_REST_CALLER_ID = '755e6f29-b7c8-4b98-8739-a1a7096f879e'

  if LFSOAP::CONST_ENV == 'QA'
    CONST_ACCOUNT = 'ltrc_tinsoap@leapfrog.test'
    CONST_DEV_SERIAL = 'LPxyz123321xyz201408271348033'
  else
    CONST_ACCOUNT = 'ltrc_automation_prod@leapfrog.test'
    CONST_DEV_SERIAL = 'LPxyz123321xyz201408271422049'
  end

  CONST_PROJECT_PATH = File.expand_path('..', File.dirname(__FILE__))
end

class LFWSDL
  CONST_CHILD_MGT = "#{LFSOAP::CONST_URL}/ChildManagementService?wsdl"
  CONST_CUSTOMER_MGT = "#{LFSOAP::CONST_URL}/CustomerManagementService?wsdl"
  CONST_AUTHENTICATION = "#{LFSOAP::CONST_URL}/AuthenticationService?wsdl"
  CONST_DEVICE_MGT = "#{LFSOAP::CONST_URL}/DeviceManagementService?wsdl"
  CONST_OWNER_MGT = "#{LFSOAP::CONST_URL}/OwnerManagementService?wsdl"
  CONST_DEVICE_PROFILE_MGT = "#{LFSOAP::CONST_URL}/DeviceProfileManagementService?wsdl"
  CONST_PACKAGE_MGT = "#{LFSOAP::CONST_URL}/PackageManagementService?wsdl"
  CONST_LICENSE_MGT = "#{LFSOAP::CONST_URL}/LicenseManagementService?wsdl"
  CONST_REWARD_SERVICE = "#{LFSOAP::CONST_URL}/RewardService?wsdl"
  CONST_DEVICE_PROFILE_CONTENT = "#{LFSOAP::CONST_URL}/DeviceProfileContentService?wsdl"
  CONST_DEVICE_LOG_UPLOAD = "#{LFSOAP::CONST_DEVICE_LOG_UPLOAD_LINK}/DeviceLogUploadService?wsdl"
  CONST_ASSET = "#{LFSOAP::CONST_URL}/AssetService?wsdl"
  CONST_CONTAINER_MGT = "#{LFSOAP::CONST_URL}/ContainerManagementService?wsdl"
  CONST_CALLER_ID = "#{LFSOAP::CONST_URL}/CallerIdService?wsdl"
  CONST_CONTENT_FEED = "#{LFSOAP::CONST_URL}/ContentFeedService?wsdl"
  CONST_CURRICULUM = "#{LFSOAP::CONST_URL}/CurriculumService?wsdl"
  CONST_PIN_MGT = "#{LFSOAP::CONST_URL}/PinManagementService?wsdl"
  CONST_SOFT_GOOD_MGT = "#{LFSOAP::CONST_URL}/SoftGoodManagementService?wsdl"
  CONST_MICROMOD_STORE = "#{LFSOAP::CONST_URL}/MicromodStoreService?wsdl"
  CONST_PRODUCT_REGISTRATION = "#{LFSOAP::CONST_URL}/ProductRegistrationService?wsdl"
  CONST_RECOMMENDATION = "#{LFSOAP::CONST_URL}/RecommendationService?wsdl"
  CONST_SURVEY = "#{LFSOAP::CONST_URL}/SurveyService?wsdl"
end

class MysqlStringConst
  CONST_FETCH_DEVICE = "select * from ws_restfulcalls where rest_service = 'fetch_device' and Run = 'Yes' and env = '#{LFSOAP::CONST_ENV}'"
  CONST_GET_DEVICE_INVENTORY = "select * from ws_restfulcalls where rest_service = 'get_device_inventory' and Run = 'Yes' and env = '#{LFSOAP::CONST_ENV}'"
  CONST_AUTHORIZE_INSTALLATION = "select * from ws_restfulcalls where rest_service = 'authorize_installation' and Run = 'Yes' and env = '#{LFSOAP::CONST_ENV}'"
  CONST_GET_PACKAGE_DEPENDENCIES = "select * from ws_restfulcalls where rest_service = 'get_package_dependencies' and Run = 'Yes' and env = '#{LFSOAP::CONST_ENV}'"
  CONST_REPORT_INSTALLATION = "select * from ws_restfulcalls where rest_service = 'report_installation' and Run = 'Yes' and env = '#{LFSOAP::CONST_ENV}'"
  CONST_UPDATE_PROFILES = "select * from ws_restfulcalls where rest_service = 'update_profiles' and Run = 'Yes' and env = '#{LFSOAP::CONST_ENV}'"
  CONST_REMOVE_INSTALLATION = "select * from ws_restfulcalls where rest_service = 'remove_installation' and Run = 'Yes' and env = '#{LFSOAP::CONST_ENV}'"

  # for JUMP services
  CONST_PUT_PETATHLON_COMPANION_APP_DATA = "select * from ws_restfulcalls where rest_service = 'JUMP_put_petathlon_companion_app_data' and Run = 'Yes' and env = '#{LFSOAP::CONST_ENV}'"
  CONST_PUT_LEAPBAND_DATA = "select * from ws_restfulcalls where rest_service = 'JUMP_put_leapband_data' and Run = 'Yes' and env = '#{LFSOAP::CONST_ENV}' ORDER BY id ASC"
  CONST_GET_LEAPBAND_DATA = "select * from ws_restfulcalls where rest_service = 'JUMP_get_leapband_data' and Run = 'Yes'  and env = '#{LFSOAP::CONST_ENV}' ORDER BY id ASC"
  CONST_GET_ALL_BUCKETS = "select * from ws_restfulcalls where rest_service = 'JUMP_get_all_buckets' and Run = 'Yes'  and env = '#{LFSOAP::CONST_ENV}' ORDER BY id ASC"
  CONST_PUT_MULTIPLE_BUCKETS = "select * from ws_restfulcalls where rest_service = 'JUMP_put_multiple_buckets' and Run = 'Yes'  and env = '#{LFSOAP::CONST_ENV}' ORDER BY id ASC"
  CONST_PUT_PETATHLON_UPDATE_FIELDS = "select * from ws_restfulcalls where rest_service = 'JUMP_put_petathlon_update_fields' and Run = 'Yes' and env = '#{LFSOAP::CONST_ENV}'"
  CONST_GET_PETATHLON_COMPANION_APP_DATA = "select * from ws_restfulcalls where rest_service = 'JUMP_get_petathlon_companion_app_data' and Run = 'Yes' and env = '#{LFSOAP::CONST_ENV}'"
end

class ErrorMessageConst
  INVALID_EMAIL_MESSAGE = 'The email address or password you entered is incorrect. Please try again.'
  INVALID_PASSWORD_MESSAGE = 'The password or email address you entered is incorrect. Please try again.'
end
