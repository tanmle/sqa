class Sqaauto479CreateEnvVersionsActiveRecordDatabaseEntriesUpdateBlobToJson < ActiveRecord::Migration
  def up
    say 'SQAAUTO-479 Create EnvVersion ActiveRecord model and db entries EnvVersion(id, env, service_app, instance, version, note)'

    @connection = ActiveRecord::Base.connection
    say 'Update to store json data into blob data field'

    # Dev env
    @connection.execute 'UPDATE env_versions SET services = \'{ "env": "Dev", "name": "ATG", "instances": "dev-www", "path": "/en-us/store/version.jsp" }\' WHERE id = 1'
    @connection.execute 'UPDATE env_versions SET services = \'{ "env": "Dev", "name": "CSTools", "instances": "emdlcsapp01,emdlcsapp02", "path": ":8080/customerservicetools/maven/versions.txt" }\' WHERE id = 2'
    @connection.execute 'UPDATE env_versions SET services = \'{ "env": "Dev", "name": "GeoIpLookup", "instances": "dev-geo", "path": ":8080/geoip-lookup/maven/versions.txt" }\' WHERE id = 3'
    @connection.execute 'UPDATE env_versions SET services = \'{ "env": "Dev", "name": "INMON-CIS", "instances": "emdlcis,emdlcis01", "path": ":8080/inmon/maven/versions.txt" }\' WHERE id = 4'
    @connection.execute 'UPDATE env_versions SET services = \'{ "env": "Dev", "name": "INMON-CIS2", "instances": "emdlcis2,emdlcis2app01,emdlcis2app02", "path": ":8080/inmon/maven/versions.txt" }\' WHERE id = 5'
    @connection.execute 'UPDATE env_versions SET services = \'{ "env": "Dev", "name": "INMON-CLP", "instances": "emdlclp01", "path": ":8080/inmon/maven/versions.txt" }\' WHERE id = 6'
    @connection.execute 'UPDATE env_versions SET services = \'{ "env": "Dev", "name": "INMON-DLOG", "instances": "emdldlog,emdldlog01,emdldlog02", "path": ":8085/inmon/maven/versions.txt" }\' WHERE id = 7'
    @connection.execute 'UPDATE env_versions SET services = \'{ "env": "Dev", "name": "LeapTV", "instances": "dev-leaptv", "path": "/register/version.php", "protocol": "https://" }\' WHERE id = 8'
    @connection.execute 'UPDATE env_versions SET services = \'{ "env": "Dev", "name": "LFCam", "instances": "emdllfcam01,emdllfcam02", "path": ":8090/lfcam/maven/versions.txt" }\' WHERE id = 9'
    @connection.execute 'UPDATE env_versions SET services = \'{ "env": "Dev", "name": "PinGen", "instances": "emdlpin01", "path": ":8080/pingen/maven/versions.txt" }\' WHERE id = 10'

    # QA env
    @connection.execute 'UPDATE env_versions SET services = \'{ "env": "QA", "name": "CSTools", "instances": "emqlcsapp01,emqlcsapp02", "path": ":8080/customerservicetools/maven/versions.txt" }\' WHERE id = 11'
    @connection.execute 'UPDATE env_versions SET services = \'{ "env": "QA", "name": "GeoIpLookup", "instances": "qa-geo", "path": ":8080/geoip-lookup/maven/versions.txt" }\' WHERE id = 12'
    @connection.execute 'UPDATE env_versions SET services = \'{ "env": "QA", "name": "INMON-CIS", "instances": "emqlcis,emqlcis01,emqlcis02", "path": ":8080/inmon/maven/versions.txt" }\' WHERE id = 13'
    @connection.execute 'UPDATE env_versions SET services = \'{ "env": "QA", "name": "INMON-CIS2", "instances": "emqlcis2,emqlcis2app01,emqlcis2app02", "path": ":8080/inmon/maven/versions.txt" }\' WHERE id = 14'
    @connection.execute 'UPDATE env_versions SET services = \'{ "env": "QA", "name": "INMON-CLP", "instances": "emqlclp,emqlclp01,emqlclp02", "path": ":8080/inmon/maven/versions.txt" }\' WHERE id = 15'
    @connection.execute 'UPDATE env_versions SET services = \'{ "env": "QA", "name": "INMON-DLOG", "instances": "emqldlog,emqldlog01,emqldlog02", "path": ":8085/inmon/maven/versions.txt" }\' WHERE id = 16'
    @connection.execute 'UPDATE env_versions SET services = \'{ "env": "QA", "name": "LeapTV", "instances": "qa-leaptv", "path": "/register/version.php", "protocol": "https://" }\' WHERE id = 17'
    @connection.execute 'UPDATE env_versions SET services = \'{ "env": "QA", "name": "LFCam", "instances": "emqllfcam01,emqllfcam02", "path": ":8090/lfcam/maven/versions.txt" }\' WHERE id = 18'
    @connection.execute 'UPDATE env_versions SET services = \'{ "env": "QA", "name": "PinGen", "instances": "emqlpin01", "path": ":8080/pingen/maven/versions.txt" }\' WHERE id = 19'

    # UAT env
    @connection.execute 'UPDATE env_versions SET services = \'{ "env": "UAT", "name": "ATG", "instances": "uat-www", "path": "/en-us/store/version.jsp" }\' WHERE id = 20'

    # Staging env
    @connection.execute 'UPDATE env_versions SET services = \'{ "env": "Staging", "name": "GeoIpLookup", "instances": "staging-geo", "path": ":8080/geoip-lookup/maven/versions.txt" }\' WHERE id = 21'
    @connection.execute 'UPDATE env_versions SET services = \'{ "env": "Staging", "name": "INMON-CIS2", "instances": "emrlcis2app01", "path": ":8080/inmon/maven/versions.txt" }\' WHERE id = 22'
    @connection.execute 'UPDATE env_versions SET services = \'{ "env": "Staging", "name": "LeapTV", "instances": "staging-leaptv", "path": "/register/version.php", "protocol": "https://" }\' WHERE id = 23'

    # Prod env
    @connection.execute 'UPDATE env_versions SET services = \'{ "env": "Prod", "name": "ATG", "instances": "www", "path": "/en-us/store/version.jsp" }\' WHERE id = 24'
    @connection.execute 'UPDATE env_versions SET services = \'{ "env": "Prod", "name": "CSTools", "instances": "evplcsapp01,evplcsapp02,evplcsapp03,evplcsapp04", "path": ":8080/customerservicetools/maven/versions.txt" }\' WHERE id = 25'
    @connection.execute 'UPDATE env_versions SET services = \'{ "env": "Prod", "name": "GeoIpLookup", "instances": "geo", "path": ":8080/geoip-lookup/maven/versions.txt" }\' WHERE id = 26'
    @connection.execute 'UPDATE env_versions SET services = \'{ "env": "Prod", "name": "INMON-CIS", "instances": "evplcis,evplcis01,evplcis02,evplcis03,evplcis04,evplcis05,evplcis06,evplcis07,evplcis08", "path": ":8080/inmon/maven/versions.txt" }\' WHERE id = 27'
    @connection.execute 'UPDATE env_versions SET services = \'{ "env": "Prod", "name": "INMON-CIS2", "instances": "evplcis2,evplcis2app01,evplcis2app02,evplcis2app03,evplcis2app04,evplcis2app05,evplcis2app06", "path": ":8080/inmon/maven/versions.txt" }\' WHERE id = 28'
    @connection.execute 'UPDATE env_versions SET services = \'{ "env": "Prod", "name": "INMON-CLP", "instances": "evplclp,evplclp01,evplclp02,evplclp03,evplclp04", "path": ":8080/inmon/maven/versions.txt" }\' WHERE id = 29'
    @connection.execute 'UPDATE env_versions SET services = \'{ "env": "Prod", "name": "INMON-DLOG", "instances": "evpldlog,evpldlog01,evpldlog02,evpldlog03,evpldlog04,evpldlog05,evpldlog06", "path": ":8085/inmon/maven/versions.txt" }\' WHERE id = 30'
    @connection.execute 'UPDATE env_versions SET services = \'{ "env": "Prod", "name": "LeapTV", "instances": "leaptv", "path": "/register/version.php", "protocol": "https://" }\' WHERE id = 31'
    @connection.execute 'UPDATE env_versions SET services = \'{ "env": "Prod", "name": "LFCam", "instances": "evpllfcam,evpllfcam01,evpllfcam02,evpllfcam03,evpllfcam04,evpllfcam05,evpllfcam06,evpllfcam07,evpllfcam08", "path": ":8090/lfcam/maven/versions.txt" }\' WHERE id = 32'
    @connection.execute 'UPDATE env_versions SET services = \'{ "env": "Prod", "name": "PinGen", "instances": "evplpin01", "path": ":8080/pingen/maven/versions.txt" }\' WHERE id = 33'
  end
end
