require 'base64'

class DeviceLogUpload
  def self.upload_device_log(caller_id, filename, slot, device_serial, local_time, log_data)
    LFCommon.soap_call(
      LFWSDL::CONST_DEVICE_LOG_UPLOAD,
      :upload_device_log,
      "<caller-id>#{caller_id}</caller-id>
      <device-log filename='#{filename}' slot='#{slot}' device-serial='#{device_serial}' local-time='#{local_time}'/>
      <device-log-data>#{log_data}</device-log-data>"
    )
  end

  def self.upload_game_log(caller_id, child_id, local_time, filename, content_path)
    # Encode log file
    content = (File.exist? content_path) ? Base64.encode64(File.read(content_path)) : ''

    # Call 'upload_game_log' method
    message = " <caller-id>#{caller_id}</caller-id>
                  <log child-id='#{child_id}' local-time='#{local_time}' filename='#{filename}'/>
                  <content>#{content}</content>"

    client = Savon.client(endpoint: LFSOAP::CONST_GAME_LOG_UPLOAD_LINK, namespace: 'http://services.leapfrog.com/inmon/device/logs/upload/', log: true, pretty_print_xml: true)
    res = client.call(:upload_game_log, message: message)

    Nokogiri::XML(res.to_xml)
  rescue Savon::SOAPFault => error
    faultstring = error.to_hash[:fault][:faultstring].to_s
    faultstring << '' << error.to_hash[:fault][:detail][:access_denied] if faultstring == 'AccessDeniedFault'

    faultstring
  rescue => e
    e.to_s
  end
end
