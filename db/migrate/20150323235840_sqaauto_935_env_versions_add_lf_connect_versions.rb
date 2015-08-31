class Sqaauto935EnvVersionsAddLfConnectVersions < ActiveRecord::Migration
  def up
    @connection = ActiveRecord::Base.connection
    say "SQAAUTO-935 [Q1_S9] Env Versions - add LF Connect versions"

    services_json = '
      {
        "services":[
          {
             "endpoints":[],
             "env":"Dev",
             "instances":"dev-www",
             "name":"ATG",
             "path":"/en-us/store/version.jsp"
          },
          {
             "endpoints":[],
             "env":"Dev",
             "instances":"emdlcsapp01,emdlcsapp02",
             "name":"CSTools",
             "path":":8080/customerservicetools/maven/versions.txt"
          },
          {
             "endpoints":[],
             "env":"Dev",
             "instances":"dev-geo",
             "name":"GeoIpLookup",
             "path":":8080/geoip-lookup/maven/versions.txt"
          },
          {
             "endpoints":[],
             "env":"Dev",
             "instances":"emdlcis,emdlcis01",
             "name":"INMON-CIS",
             "path":":8080/inmon/maven/versions.txt"
          },
          {
             "endpoints":[],
             "env":"Dev",
             "instances":"emdlcis2,emdlcis2app01,emdlcis2app02",
             "name":"INMON-CIS2",
             "path":":8080/inmon/maven/versions.txt"
          },
          {
             "endpoints":[],
             "env":"Dev",
             "instances":"emdlclp01",
             "name":"INMON-CLP",
             "path":":8080/inmon/maven/versions.txt"
          },
          {
             "endpoints":[],
             "env":"Dev",
             "instances":"emdldlog,emdldlog01,emdldlog02",
             "name":"INMON-DLOG",
             "path":":8085/inmon/maven/versions.txt"
          },
          {
             "endpoints":[],
             "env":"Dev",
             "instances":"dev-leaptv",
             "name":"LeapTV Register",
             "path":"/register/version.php",
             "protocol":"https://"
          },
          {
             "endpoints":[],
             "env":"Dev",
             "instances":"emdllfcam01,emdllfcam02",
             "name":"LFCam",
             "path":":8090/lfcam/maven/versions.txt",
              "vips": ["http://dev-lfcam.leapfrog.com/lfcam/maven/versions.txt"]
          },
          {
            "endpoints": [],
            "env": "Dev",
            "instances": "emdlcp2app01,emdlcp2app02",
            "name": "LFConnect",
            "path": ":8080/lexplorer/maven/versions.txt",
            "vips": ["http://dev-lfconnect.leapfrog.com/lexplorer/maven/versions.txt"]
          },
          {
             "endpoints":[],
             "env":"Dev",
             "instances":"emdlpin01",
             "name":"PinGen",
             "path":":8080/pingen/maven/versions.txt"
          },
          {
             "endpoints":[],
             "env":"QA",
             "instances":"emqlcsapp01,emqlcsapp02",
             "name":"CSTools",
             "path":":8080/customerservicetools/maven/versions.txt"
          },
          {
             "endpoints":[],
             "env":"QA",
             "instances":"qa-geo",
             "name":"GeoIpLookup",
             "path":":8080/geoip-lookup/maven/versions.txt"
          },
          {
             "endpoints":[],
             "env":"QA",
             "instances":"emqlcis,emqlcis01,emqlcis02",
             "name":"INMON-CIS",
             "path":":8080/inmon/maven/versions.txt"
          },
          {
             "endpoints":[],
             "env":"QA",
             "instances":"emqlcis2,emqlcis2app01,emqlcis2app02",
             "name":"INMON-CIS2",
             "path":":8080/inmon/maven/versions.txt"
          },
          {
             "endpoints":[],
             "env":"QA",
             "instances":"emqlclp,emqlclp01,emqlclp02",
             "name":"INMON-CLP",
             "path":":8080/inmon/maven/versions.txt"
          },
          {
             "endpoints":[],
             "env":"QA",
             "instances":"emqldlog,emqldlog01,emqldlog02",
             "name":"INMON-DLOG",
             "path":":8085/inmon/maven/versions.txt"
          },
          {
             "endpoints":[],
             "env":"QA",
             "instances":"qa-leaptv",
             "name":"LeapTV Register",
             "path":"/register/version.php",
             "protocol":"https://"
          },
          {
             "endpoints":[],
             "env":"QA",
             "instances":"emqllfcam01,emqllfcam02",
             "name":"LFCam",
             "path":":8090/lfcam/maven/versions.txt",
             "vips": ["http://qa-lfcam.leapfrog.com/lfcam/maven/versions.txt"]
          },
          {
            "endpoints": [],
            "env": "QA",
            "instances": "emqlcp2app01,emqlcp2app02",
            "name": "LFConnect",
            "path": ":8080/lexplorer/maven/versions.txt",
            "vips": ["http://qa-lfconnect.leapfrog.com/lexplorer/maven/versions.txt"]
          },
          {
             "endpoints":[],
             "env":"QA",
             "instances":"emqlpin01",
             "name":"PinGen",
             "path":":8080/pingen/maven/versions.txt"
          },
          {
             "endpoints":[],
             "env":"UAT",
             "instances":"uat-www",
             "name":"ATG",
             "path":"/en-us/store/version.jsp"
          },
          {
             "endpoints":[],
             "env":"Staging",
             "instances":"staging-geo",
             "name":"GeoIpLookup",
             "path":":8080/geoip-lookup/maven/versions.txt"
          },
          {
             "endpoints":[],
             "env":"Staging",
             "instances":"emrlcis2app01",
             "name":"INMON-CIS2",
             "path":":8080/inmon/maven/versions.txt"
          },
          {
             "endpoints":[],
             "env":"Staging",
             "instances":"staging-leaptv",
             "name":"LeapTV Register",
             "path":"/register/version.php",
             "protocol":"https://"
          },
          {
            "endpoints": [],
            "env": "Staging",
            "instances": "emrlcp2app02",
            "name": "LFConnect",
            "path": ":8080/lexplorer/maven/versions.txt",
            "vips": ["http://qa-lfconnect.leapfrog.com/lexplorer/maven/versions.txt"]
          },
          {
             "endpoints":[],
             "env":"Prod",
             "instances":"www",
             "name":"ATG",
             "path":"/en-us/store/version.jsp"
          },
          {
             "endpoints":[],
             "env":"Prod",
             "instances":"evplcsapp01,evplcsapp02,evplcsapp03,evplcsapp04",
             "name":"CSTools",
             "path":":8080/customerservicetools/maven/versions.txt"
          },
          {
             "endpoints":[],
             "env":"Prod",
             "instances":"geo",
             "name":"GeoIpLookup",
             "path":":8080/geoip-lookup/maven/versions.txt"
          },
          {
             "endpoints":[],
             "env":"Prod",
             "instances":"evplcis,evplcis01,evplcis02,evplcis03,evplcis04,evplcis05,evplcis06,evplcis07,evplcis08",
             "name":"INMON-CIS",
             "path":":8080/inmon/maven/versions.txt"
          },
          {
             "endpoints":[],
             "env":"Prod",
             "instances":"evplcis2,evplcis2app01,evplcis2app02,evplcis2app03,evplcis2app04,evplcis2app05,evplcis2app06",
             "name":"INMON-CIS2",
             "path":":8080/inmon/maven/versions.txt"
          },
          {
             "endpoints":[],
             "env":"Prod",
             "instances":"evplclp,evplclp01,evplclp02,evplclp03,evplclp04",
             "name":"INMON-CLP",
             "path":":8080/inmon/maven/versions.txt"
          },
          {
             "endpoints":[],
             "env":"Prod",
             "instances":"evpldlog,evpldlog01,evpldlog02,evpldlog03,evpldlog04,evpldlog05,evpldlog06",
             "name":"INMON-DLOG",
             "path":":8085/inmon/maven/versions.txt"
          },
          {
             "endpoints":[],
             "env":"Prod",
             "instances":"leaptv",
             "name":"LeapTV Register",
             "path":"/register/version.php",
             "protocol":"https://"
          },
          {
             "endpoints":[],
             "env":"Prod",
             "instances":"evpllfcam,evpllfcam01,evpllfcam02,evpllfcam03,evpllfcam04,evpllfcam05,evpllfcam06,evpllfcam07,evpllfcam08",
             "name":"LFCam",
             "path":":8090/lfcam/maven/versions.txt",
             "vips": ["http://lfcam.leapfrog.com/lfcam/maven/versions.txt"]
          },
          {
            "endpoints": [],
            "env": "Prod",
            "instances": "",
            "name": "LFConnect",
            "path": ":8080/lexplorer/maven/versions.txt",
            "vips": ["http://lfconnect.leapfrog.com/lexplorer/maven/versions.txt"]
          },
          {
             "endpoints":[],
             "env":"Prod",
             "instances":"evplpin01",
             "name":"PinGen",
             "path":":8080/pingen/maven/versions.txt"
          }
        ]
      }'
    @connection.execute "
    insert env_versions(
      id, 
      services, 
      updated_at
    ) 
    values (
      (select s.id + 1 from env_versions as s order by s.id desc limit 1),
      '#{services_json}',
      utc_timestamp()
    );"
  end
end