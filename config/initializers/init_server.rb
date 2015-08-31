require 'rexml/document'

def xml_file_to_hash(filename)
  xml = Nokogiri::XML(File.read(filename))
  Hash.from_xml(xml.to_s)
end

def to_pretty_xml(xml)
  pretty_xml = ''
  formatter = REXML::Formatters::Pretty.new
  formatter.compact = true
  formatter.write REXML::Document.new(xml), pretty_xml
  pretty_xml
end

default_config = xml_file_to_hash ENV['CONFIG_FILE']

conf = Rails.application.config

# Configure email server
conf.action_mailer.delivery_method = :smtp

config_data = {
  authentication: 'plain',
  enable_starttls_auto: true
}

conf.action_mailer.smtp_settings = config_data

machine_default = {
  'configuration' => {
    'machineSettings' => {
      'stationName' => '',
      'networkName' => conf.server_name,
      'ip' => conf.server_ip,
      'port' => conf.server_port
    }
  }
}

machine_config = {}
machine_config = xml_file_to_hash ENV['MACHINE_FILE'] if File.exist?(ENV['MACHINE_FILE'])

# Add missing settings
machine_default.deep_merge!(machine_config)
machine_default.deep_merge!(default_config) { |_key, v1, _v2| v1 }

pretty_xml = to_pretty_xml machine_default['configuration'].to_xml(root: 'configuration').gsub('nil="true"', '')
File.open(ENV['MACHINE_FILE'], 'w') { |xml| xml.write pretty_xml }

conf.server_role = machine_default['configuration']['machineSettings']['stationName']
conf.server_name = machine_default['configuration']['machineSettings']['networkName']
conf.action_mailer.smtp_settings = machine_default['configuration']['smtpSetting']
