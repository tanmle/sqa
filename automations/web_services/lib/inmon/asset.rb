class Asset
  def self.fetch_container(caller_id, device_serial, container_id)
    LFCommon.soap_call(
      LFWSDL::CONST_ASSET,
      :fetch_container,
      "<caller-id>#{caller_id}</caller-id>
      <device serial='#{device_serial}' product-id='0' platform='leapad3' auto-create='false'/>
      <container id='#{container_id}'/>"
    )
  end
end
