class MicromodStore
  def self.purchase(caller_id, device_serial, slot, package_id, package_name, checksum, href, type, status, cost)
    LFCommon.soap_call(
      LFWSDL::CONST_MICROMOD_STORE,
      :purchase,
      "<caller-id>#{caller_id}</caller-id>
      <device-serial>#{device_serial}</device-serial>
      <slot>#{slot}</slot>
      <package id='#{package_id}' name='#{package_name}' checksum='#{checksum}' href='#{href}' type='#{type}' status='#{status}'/>
      <cost>#{cost}</cost>"
    )
  end
end
