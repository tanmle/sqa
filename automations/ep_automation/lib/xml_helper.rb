require 'nokogiri'

class XMLHelper
  def initialize(xmlFile)
    @xmlFile = xmlFile
  end

  # Get node values
  # @xpath: the xml path to an element
  # @return: array of values
  def getNodeValues(xpath)
    #lst = Array.new()
		lst = []
    if File.exist?(@xmlFile)
      f = File.open(@xmlFile)
      doc = Nokogiri::XML(f)
      items = doc.xpath(xpath)
      items.map{
        |e| lst.push [e.text]}
      f.close
    else
      puts "File does not exist"
    end
    return items
  end

end