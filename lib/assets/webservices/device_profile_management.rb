class DeviceProfileManagement
  attr_accessor :wsdl
  CONST_CALLER_ID = ENV['CONST_CALLER_ID']

  def initialize(env = 'QA')
    @wsdl = CommonMethods.get_wsdl ENV['CONST_DEVICE_PROFILE_MGT'], env
  end

  def assign_device_profile(customer_id, device_serial, platform, slot, profile_name, child_id)
    CommonMethods.soap_call(
      @wsdl,
      :assign_device_profile,
      "<caller-id>#{CONST_CALLER_ID}</caller-id>
      <username/>
      <customer-id>#{customer_id}</customer-id>
      <device-profile device='#{device_serial}' platform='#{platform}' slot='#{slot}' name='#{profile_name}' child-id='#{child_id}'/>
      <child-id>#{child_id}</child-id>"
    )
  end
end
