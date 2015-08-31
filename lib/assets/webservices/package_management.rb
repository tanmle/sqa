class PackageManagement
  attr_accessor :wsdl
  CONST_CALLER_ID = ENV['CONST_CALLER_ID']

  def initialize(env = 'QA')
    @wsdl = CommonMethods.get_wsdl ENV['CONST_PACKAGE_MGT'], env
  end

  def report_installation(session, device_serial, package_id, license_id)
    CommonMethods.soap_call(
      @wsdl,
      :report_installation,
      "<caller-id>#{CONST_CALLER_ID}</caller-id>
       <session type='service'>#{session}</session>
       <device-serial>#{device_serial}</device-serial>
       <slot>0</slot>
       <package id='#{package_id}' name='' checksum='' href='' type='' status='' lictype='' productId='' platform='' locale=''/>
       <license id='#{license_id}' key='' type='' count='' package-id='' grant-date=''/>"
    )
  end

  def remove_installation(session, device_serial, package_id, slot)
    CommonMethods.soap_call(
      @wsdl,
      :remove_installation,
      "<caller-id>#{CONST_CALLER_ID}</caller-id>
      <session type='service'>#{session}</session>
      <device-serial>#{device_serial}</device-serial>
      <slot>#{slot}</slot>
      <package id='#{package_id}' name='' checksum='' href='' type='Application' status='' lictype='' productId='' platform='' locale=''/>"
    )
  end

  def device_inventory(session, device_serial)
    CommonMethods.soap_call(
      @wsdl,
      :device_inventory,
      "<caller-id>#{CONST_CALLER_ID}</caller-id>
      <session type='service'>#{session}</session>
      <device-serial>#{device_serial}</device-serial>
      <include-license-type>Application</include-license-type>"
    )
  end

  def get_device_licenses(session, device_info)
    license_info = []
    device_info.each do |device|
      res_xml = device_inventory(session, device[:serial])

      return license_info if res_xml[0] == 'error'
      res_xml.xpath('//device/package').each do |el|
        package_id = el['id']
        package_name = el['name'].gsub('(virtual)', '').strip
        status = el['status']
        slot = el.parent['number'] if status == 'installed'
        license_info.push(device_serial: device[:serial], package_id: package_id, package_name: package_name, status: status, slot: slot)
      end
    end
    license_info
  end

  def get_package_name(package_id)
    res_xml = CommonMethods.soap_call(
      @wsdl,
      :package_versions,
      "<caller-id>#{CONST_CALLER_ID}</caller-id>
      <package-version>
        <package name='' code='' uri='' checksum='' id='#{package_id}' universal-id='' version='' version-date='' min-version='' status='' display-name='' hidden='true' size='' preview-image-url='' category='' locale=''></package>
        <dependencies/>
      </package-version>"
    )

    return '' if res_xml[0] == 'error'
    res_xml.xpath('//package').each do |el|
      return el['name'].gsub('(virtual)', '').strip
    end
  end
end
