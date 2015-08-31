class ContainerManagement
  def self.create_container(caller_id, customer_id)
    LFCommon.soap_call(
      LFWSDL::CONST_CONTAINER_MGT,
      :create_container,
      "<caller-id>#{caller_id}</caller-id>
      <customer-id>#{customer_id}</customer-id>"
    )
  end

  def self.add_package(caller_id, container_id, package_name, code, uri, checksum)
    LFCommon.soap_call(
      LFWSDL::CONST_CONTAINER_MGT,
      :add_package,
      "<caller-id>#{caller_id}</caller-id>
      <container id='#{container_id}'/>
      <package name='#{package_name}' code='#{code}' uri='#{uri}' checksum='#{checksum}' id='' version='' min-version='' status='' locale=''/>"
    )
  end
end
