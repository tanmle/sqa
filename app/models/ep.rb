class Ep < ActiveRecord::Base
  def self.update_data_info_to_xml(path, data)
    xml_content = Nokogiri::XML(File.read(path))
    xml_content.search('//information/webdriver')[0].inner_html = data[:web_driver].to_s
    xml_content.search('//information/env')[0].inner_html = data[:env].to_s
    xml_content.search('//information/locale')[0].inner_html = data[:locale].to_s
    xml_content.search('//information/releasedate')[0].inner_html = data[:release_date].to_s
    File.open(path, 'w') { |f| f.print(xml_content.to_xml) }
  end
end
