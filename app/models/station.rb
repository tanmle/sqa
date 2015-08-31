class Station < ActiveRecord::Base
  self.primary_key = 'network_name'
  SUCCESSFUL_UPDATE = 1
  FAIL_UPDATE = 0
  MACHINE_FILE = ENV['MACHINE_FILE']

  def init_server_on_db
    xml_content = Nokogiri::XML(File.read(MACHINE_FILE))
    station_name = xml_content.search('//machineSettings/stationName').text
    network_name = xml_content.search('//machineSettings/networkName').text
    ip_address = xml_content.search('//machineSettings/ip').text
    port = xml_content.search('//machineSettings/port').text.to_i
    st = Station.where(network_name: network_name)
    if st.size == 0
      st = Station.new(network_name: network_name, station_name: station_name, ip: ip_address, port: port)
      Rails.logger.info "Inserted station: #{network_name} into DB successful" if st.save
    else
      Rails.application.config.server_role = false if st[0].network_name != network_name || st[0].station_name != station_name || st[0].ip != ip_address || st[0].port != port
    end
  end

  def self.update_machine_config(station_name, network_name, ip_address, port)
    begin
      Station.where(network_name: network_name).update_all(station_name: station_name, ip: ip_address, port: port)

      xml_content = Nokogiri::XML(File.read(MACHINE_FILE))
      xml_content.search('//machineSettings/stationName')[0].inner_html = station_name
      xml_content.search('//machineSettings/ip')[0].inner_html = ip_address
      xml_content.search('//machineSettings/port')[0].inner_html = port
      File.open(MACHINE_FILE, 'w') { |f| f.print(xml_content.to_xml) }
    rescue
      return FAIL_UPDATE
    end
    SUCCESSFUL_UPDATE
  end

  def self.station_list_html
    Station.all.reduce('') { |a, e| a + e.to_html }.html_safe
  end

  def self.location_list(page = 'new_run')
  stations = Station.select(:station_name, :network_name).order(:station_name)
  return stations.pluck(:network_name, :station_name) if page == 'new_run'
  stations.pluck(:station_name, :network_name)
  end

  def to_html
    "<tr class=\"bout\">
    <td>#{network_name}</td>
    <td>#{station_name}</td>
    <td>#{ip}</td>
    <td>#{port}</td>
    <td><a href='#{Rails.application.config.server_protocol}://#{ip}:#{port}/admin/stations' target='_blank'>Edit</a></td></tr>"
  end

  def self.station_name(network_name)
    station = Station.find_by(network_name: network_name)
    return '' if station.blank?
    station.station_name
  end

  def self.next_station(recent_station)
    station_arr = Station.select(:station_name, :network_name).order(:station_name).pluck(:network_name)
    return station_arr[0] if recent_station.blank?

    index = station_arr.find_index(recent_station)
    return station_arr[0] if index.nil? || index == station_arr.size - 1
    station_arr[index + 1]
  end

  def self.assign_station(selected_station)
    if selected_station == 'ANY'
      station = next_station $recent_station
    else
      station = selected_station
    end

    $recent_station = station
  end
end
