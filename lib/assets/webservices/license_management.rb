require 'time'

class LicenseManagement
  attr_accessor :wsdl
  CONST_CALLER_ID = ENV['CONST_CALLER_ID']

  def initialize(env = 'QA')
    @wsdl = CommonMethods.get_wsdl ENV['CONST_LICENSE_MGT'], env
  end

  # fetch_restricted_licenses
  def fetch_restricted_licenses(session, customer_id)
    res_xml = CommonMethods.soap_call(
      @wsdl,
      :fetch_restricted_licenses,
      "<caller-id>#{CONST_CALLER_ID}</caller-id>
      <session type='service'>#{session}</session>
      <cust-key>#{customer_id}</cust-key>"
    )

    return res_xml if res_xml[0] == 'error'
    res_xml.xpath('//licenses')
  end

  # revoke_license
  def revoke_license(session, license_id)
    res_xml = CommonMethods.soap_call(
      @wsdl,
      :revoke_license,
      "<caller-id>#{CONST_CALLER_ID}</caller-id>
      <session type='service'>#{session}</session>
      <license-id>#{license_id}</license-id>"
    )

    return res_xml if res_xml[0] == 'error'
    true
  end

  # Get revoked license list after revoking
  def get_revoked_license(restricted_licenses_res, session)
    license = ''
    restricted_licenses_res.each do |el|
      license_id = el['id']
      res_xml = revoke_license(session, license_id)
      license << license_id << ',' if res_xml == true
    end

    license
  end

  def get_all_account_licenses(session, customer_id)
    res_xml = CommonMethods.soap_call(
      @wsdl,
      :fetch_restricted_licenses,
      "<caller-id>#{CONST_CALLER_ID}</caller-id>
      <session type='service'>#{session}</session>
      <cust-key>#{customer_id}</cust-key>"
    )

    license_info = []
    return license_info if res_xml[0] == 'error'

    format_time = '%Y-%m-%d %H:%M'
    res_xml.xpath('//licenses').each do |el|
      license_id = el['id']
      sku = el['package-id']
      type = el['type']
      grant_date = Time.parse(el['grant-date']).strftime(format_time)
      license_info.push(license_id: license_id, sku: sku, type: type, grant_date: grant_date)
    end

    license_info.select { |li| li[:type] == 'purchase' }
  end
end
