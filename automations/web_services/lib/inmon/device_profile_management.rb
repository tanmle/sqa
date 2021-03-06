class DeviceProfileManagement
  def self.assign_device_profile(caller_id, customer_id, device_serial, platform, slot, profile_name, child_id)
    LFCommon.soap_call(
      LFWSDL::CONST_DEVICE_PROFILE_MGT,
      :assign_device_profile,
      "<caller-id>#{caller_id}</caller-id>
      <username/>
      <customer-id>#{customer_id}</customer-id>
      <device-profile device='#{device_serial}' platform='#{platform}' slot='#{slot}' name='#{profile_name}' child-id='#{child_id}'/>
      <child-id>#{child_id}</child-id>"
    )
  end

  def self.list_child_device_profiles(caller_id, username, customer_id, child_id)
    LFCommon.soap_call(
      LFWSDL::CONST_DEVICE_PROFILE_MGT,
      :list_child_device_profiles,
      "<caller-id>#{caller_id}</caller-id>
      <username>#{username}</username>
      <customer-id>#{customer_id}</customer-id>
      <child-id>#{child_id}</child-id>"
    )
  end

  def self.list_device_profiles(caller_id, username, customer_id, total, length, offset)
    LFCommon.soap_call(
      LFWSDL::CONST_DEVICE_PROFILE_MGT,
      :list_device_profiles,
      "<caller-id>#{caller_id}</caller-id>
      <username>#{username}</username>
      <customer-id>#{customer_id}</customer-id>
      <page total='#{total}' length='#{length}' offset='#{offset}'/>"
    )
  end
end
