class Sqaauto471DashboardVersionsFeatureSaveToDb < ActiveRecord::Migration
  def down
    drop_table :env_versions
  end

  def up
    say "Create 'env_version' table"
    create_table :env_versions do |t|
      t.binary :services
    end

    @connection = ActiveRecord::Base.connection

    say 'Initial data for env_versions table'
    
    # Dev env
    @connection.execute "INSERT INTO `env_versions`(services) VALUES (\"{ env: 'Dev', name: 'ATG', instances: 'dev-www', path: '/en-us/store/version.jsp' }\")"
    @connection.execute "INSERT INTO `env_versions`(services) VALUES (\"{ env: 'Dev', name: 'CSTools', instances: 'emdlcsapp01,emdlcsapp02', path: ':8080/customerservicetools/maven/versions.txt' }\")"
    @connection.execute "INSERT INTO `env_versions`(services) VALUES (\"{ env: 'Dev', name: 'GeoIpLookup', instances: 'dev-geo', path: ':8080/geoip-lookup/maven/versions.txt' }\")"
    @connection.execute "INSERT INTO `env_versions`(services) VALUES (\"{ env: 'Dev', name: 'INMON-CIS', instances: 'emdlcis,emdlcis01', path: ':8080/inmon/maven/versions.txt' }\")"
    @connection.execute "INSERT INTO `env_versions`(services) VALUES (\"{ env: 'Dev', name: 'INMON-CIS2', instances: 'emdlcis2,emdlcis2app01,emdlcis2app02', path: ':8080/inmon/maven/versions.txt' }\")"
    @connection.execute "INSERT INTO `env_versions`(services) VALUES (\"{ env: 'Dev', name: 'INMON-CLP', instances: 'emdlclp01', path: ':8080/inmon/maven/versions.txt' }\")"
    @connection.execute "INSERT INTO `env_versions`(services) VALUES (\"{ env: 'Dev', name: 'INMON-DLOG', instances: 'emdldlog,emdldlog01,emdldlog02', path: ':8085/inmon/maven/versions.txt' }\")"
    @connection.execute "INSERT INTO `env_versions`(services) VALUES (\"{ env: 'Dev', name: 'LeapTV', instances: 'dev-leaptv', path: '/register/version.php', protocol: 'https://' }\")"
    @connection.execute "INSERT INTO `env_versions`(services) VALUES (\"{ env: 'Dev', name: 'LFCam', instances: 'emdllfcam01,emdllfcam02', path: ':8090/lfcam/maven/versions.txt' }\")"
    @connection.execute "INSERT INTO `env_versions`(services) VALUES (\"{ env: 'Dev', name: 'PinGen', instances: 'emdlpin01', path: ':8080/pingen/maven/versions.txt' }\")"
    
    # QA env
    @connection.execute "INSERT INTO `env_versions`(services) VALUES (\"{ env: 'QA', name: 'CSTools', instances: 'emqlcsapp01,emqlcsapp02', path: ':8080/customerservicetools/maven/versions.txt' }\")"
    @connection.execute "INSERT INTO `env_versions`(services) VALUES (\"{ env: 'QA', name: 'GeoIpLookup', instances: 'qa-geo', path: ':8080/geoip-lookup/maven/versions.txt' }\")"
    @connection.execute "INSERT INTO `env_versions`(services) VALUES (\"{ env: 'QA', name: 'INMON-CIS', instances: 'emqlcis,emqlcis01,emqlcis02', path: ':8080/inmon/maven/versions.txt' }\")"
    @connection.execute "INSERT INTO `env_versions`(services) VALUES (\"{ env: 'QA', name: 'INMON-CIS2', instances: 'emqlcis2,emqlcis2app01,emqlcis2app02', path: ':8080/inmon/maven/versions.txt' }\")"
    @connection.execute "INSERT INTO `env_versions`(services) VALUES (\"{ env: 'QA', name: 'INMON-CLP', instances: 'emqlclp,emqlclp01,emqlclp02', path: ':8080/inmon/maven/versions.txt' }\")"
    @connection.execute "INSERT INTO `env_versions`(services) VALUES (\"{ env: 'QA', name: 'INMON-DLOG', instances: 'emqldlog,emqldlog01,emqldlog02', path: ':8085/inmon/maven/versions.txt' }\")"
    @connection.execute "INSERT INTO `env_versions`(services) VALUES (\"{ env: 'QA', name: 'LeapTV', instances: 'qa-leaptv', path: '/register/version.php', protocol: 'https://' }\")"
    @connection.execute "INSERT INTO `env_versions`(services) VALUES (\"{ env: 'QA', name: 'LFCam', instances: 'emqllfcam01,emqllfcam02', path: ':8090/lfcam/maven/versions.txt' }\")"
    @connection.execute "INSERT INTO `env_versions`(services) VALUES (\"{ env: 'QA', name: 'PinGen', instances: 'emqlpin01', path: ':8080/pingen/maven/versions.txt' }\")"
    
    # UAT env
    @connection.execute "INSERT INTO `env_versions`(services) VALUES (\"{ env: 'UAT', name: 'ATG', instances: 'uat-www', path: '/en-us/store/version.jsp' }\")"
    
    # Staging env
    @connection.execute "INSERT INTO `env_versions`(services) VALUES (\"{ env: 'Staging', name: 'GeoIpLookup', instances: 'staging-geo', path: ':8080/geoip-lookup/maven/versions.txt' }\")"
    @connection.execute "INSERT INTO `env_versions`(services) VALUES (\"{ env: 'Staging', name: 'INMON-CIS2', instances: 'emrlcis2app01', path: ':8080/inmon/maven/versions.txt' }\")"
    @connection.execute "INSERT INTO `env_versions`(services) VALUES (\"{ env: 'Staging', name: 'LeapTV', instances: 'staging-leaptv', path: '/register/version.php', protocol: 'https://' }\")"
    
    # Prod env
    @connection.execute "INSERT INTO `env_versions`(services) VALUES (\"{ env: 'Prod', name: 'ATG', instances: 'www', path: '/en-us/store/version.jsp' }\")"
    @connection.execute "INSERT INTO `env_versions`(services) VALUES (\"{ env: 'Prod', name: 'CSTools', instances: 'evplcsapp01,evplcsapp02,evplcsapp03,evplcsapp04', path: ':8080/customerservicetools/maven/versions.txt' }\")"
    @connection.execute "INSERT INTO `env_versions`(services) VALUES (\"{ env: 'Prod', name: 'GeoIpLookup', instances: 'geo', path: ':8080/geoip-lookup/maven/versions.txt' }\")"
    @connection.execute "INSERT INTO `env_versions`(services) VALUES (\"{ env: 'Prod', name: 'INMON-CIS', instances: 'evplcis,evplcis01,evplcis02,evplcis03,evplcis04,evplcis05,evplcis06,evplcis07,evplcis08', path: ':8080/inmon/maven/versions.txt' }\")"
    @connection.execute "INSERT INTO `env_versions`(services) VALUES (\"{ env: 'Prod', name: 'INMON-CIS2', instances: 'evplcis2,evplcis2app01,evplcis2app02,evplcis2app03,evplcis2app04,evplcis2app05,evplcis2app06', path: ':8080/inmon/maven/versions.txt' }\")"
    @connection.execute "INSERT INTO `env_versions`(services) VALUES (\"{ env: 'Prod', name: 'INMON-CLP', instances: 'evplclp,evplclp01,evplclp02,evplclp03,evplclp04', path: ':8080/inmon/maven/versions.txt' }\")"
    @connection.execute "INSERT INTO `env_versions`(services) VALUES (\"{ env: 'Prod', name: 'INMON-DLOG', instances: 'evpldlog,evpldlog01,evpldlog02,evpldlog03,evpldlog04,evpldlog05,evpldlog06', path: ':8085/inmon/maven/versions.txt' }\")"
    @connection.execute "INSERT INTO `env_versions`(services) VALUES (\"{ env: 'Prod', name: 'LeapTV', instances: 'leaptv', path: '/register/version.php', protocol: 'https://' }\")"
    @connection.execute "INSERT INTO `env_versions`(services) VALUES (\"{ env: 'Prod', name: 'LFCam', instances: 'evpllfcam,evpllfcam01,evpllfcam02,evpllfcam03,evpllfcam04,evpllfcam05,evpllfcam06,evpllfcam07,evpllfcam08', path: ':8090/lfcam/maven/versions.txt' }\")"
    @connection.execute "INSERT INTO `env_versions`(services) VALUES (\"{ env: 'Prod', name: 'PinGen', instances: 'evplpin01', path: ':8080/pingen/maven/versions.txt' }\")"
  end
end
