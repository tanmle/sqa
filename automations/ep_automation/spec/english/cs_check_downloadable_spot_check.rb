require File.expand_path('../../spec_helper', __FILE__)
require 'connection'
require 'savon'
require 'capybara/rspec'
require 'rspec/expectations'

# Get random a title from CS checking list
title = Connection.my_sql_connection("select * from ep_titles where (pricetier like 'Tier 1%' or pricetier like 'Tier 2%' or pricetier like 'Tier 3%') and licnonlic = 'Non-Licensed' and
us = 'X' and lex = 'X' ORDER BY RAND() limit 1")
title.each_hash do |t|
  $sku = t['sku']
end

# create a client for the service
client = Savon.client(wsdl: 'http://emqlcis.leapfrog.com:8080/inmon/services/LicenseManagementService?wsdl',
                      pretty_print_xml: true,
                      namespace_identifier: :man)

callerid = '755e6f29-b7c8-4b98-8739-a1a7096f879e'
session = '491309d5-c2cd-4deb-aa9d-ea426372006e'
customerkey = '2766864' # of user ltrc_thuong_10212013_qa@leapfrog.test
devicereserial = '3A1521000101FF001032' # platform="explorer2"
packageid = $sku
grantsuccess = false
installsuccess = false

# Prepair message for soap call with savon
grantLicense = "<transaction id='aaaaaaaa'/><caller-id>#{callerid}</caller-id>
               <session type='service'>#{session}</session>
               <cust-key>#{customerkey}</cust-key>
               <device-serial>#{devicereserial}</device-serial>
               <slot>0</slot>
               <package id='#{packageid}'/>
               <license-type>purchase</license-type>
               <access-level>parent</access-level>"

responseGL = client.call(:grant_license, message: grantLicense) # call grantLicense method

# set grantsuccess = true if response of grantLicense returns license id
responseGLHash = responseGL.to_hash
if !responseGLHash[:grant_license_response][:license][:@id].nil?
  grantsuccess = true
end

# Prepair message for soap call with savon
installPackage = "<caller-id>#{callerid}</caller-id>
                 <device-serial>#{devicereserial}</device-serial>
                 <slot>0</slot>
                 <package id='#{packageid}' name='' checksum='' href='n/a' type='Application' status='' lictype='' productId='' platform='' locale=''/>"

responseIP = client.call(:install_package, message: installPackage) # call installPackage method

# set installsuccess = true if response of installPackage does not return fault
responseIPHash = responseIP.to_hash
if !responseIPHash[:install_package_response][:"@xmlns:ns2"].nil?
  installsuccess = true
end

# == Checking grantLicense and Install are called successully
describe 'Check an app in CS check list are downloadable' do
  it 'Check grantLicense method is called successfully' do
    grantsuccess.should eq true
  end

  it 'Check installPackage method is called successfully' do
    expect(installsuccess).should eq true
  end
end
