require 'savon'
require 'nokogiri'

class CommonMethods
  #
  # this method make a call to service with params:
  # wsdl, method, message
  #
  def self.soap_call(wsdl, method, message)
    client = Savon.client(wsdl: wsdl, log: true, pretty_print_xml: true, namespace_identifier: :man)
    res = client.call(method, message: message)
  rescue Savon::SOAPFault => error
    ['error', error.to_hash[:fault][:faultstring]]
  else
    Nokogiri::XML(res.to_xml)
  end

  #
  # this method get WSDL base on environment
  # PROD or QA
  #
  def self.get_wsdl(method, env)
    if env == 'QA'
      "http://emqlcis.leapfrog.com:8080/inmon/services/#{method}?wsdl"
    elsif env == 'PROD'
      "http://evplcis.leapfrog.com:8080/inmon/services/#{method}?wsdl"
    elsif env == 'STAGING'
      "http://evslcis2.leapfrog.com:8080/inmon/services/#{method}?wsdl"
    end
  end

  def self.generate_screenname
    'ltrc_' + get_current_time + '_us@leapfrog.test'
  end

  #
  # return string
  # ex. 201491213182591
  #
  def self.get_current_time
    time = Time.new
    "#{time.year}#{time.month}#{time.day}#{time.hour}#{time.min}#{time.sec}"
  end
end
