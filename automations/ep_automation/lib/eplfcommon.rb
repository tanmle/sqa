require 'net/http'
require 'net/https'
require 'openssl'
require 'uri'
require 'json'
require 'savon'
require 'selenium-webdriver'
require 'capybara'
require 'roo'
require 'spreadsheet'
require 'lib/const'

class LFCommon
  Capybara.default_driver = :selenium
  include Capybara::DSL
end

class LFExcel
  def retrieve_seo_info
    file = File.join(File.expand_path('..', File.dirname(__FILE__)), 'data', 'AppCenterCatalog.xlsx')
    spreadsheet = open_spreadsheet(file)
    arr = []
    if !spreadsheet.nil?
      if spreadsheet.last_row > 1
        header = spreadsheet.row(1)
        (2..spreadsheet.last_row).each do |i|
          row = Hash[[header, spreadsheet.row(i)].transpose]
          arr.push(row)
        end
      end
    end
    arr
  end
  # open excel file
  def open_spreadsheet(file)
    case File.extname(File.basename(file))
    when '.xls'
      exl = Roo::Excel.new(file, { mode: 'r' }, :ignore)
    when '.xlsx'
      exl = Roo::Excelx.new(file, { mode: 'r' }, :ignore)
    when '.csv'
      exl = Roo::CSV.new(file, mode: 'r')
    end
    exl.sheet 0

    exl
  end
end
