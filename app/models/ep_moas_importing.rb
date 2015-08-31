class EpMoasImporting
  attr_accessor :table, :language

  def initialize(table, language)
    @table = table
    @language = language
  end

  # import data from excel to mysql
  def import(file)
    spreadsheet = ModelCommon.open_spreadsheet(file)
    return '<p class = "alert alert-error">Try to do the following instructions:<br/>
            1. Please save as the file to excel format.<br/>
            2. Make sure MOAS data in the first sheet.<br/>
            3. Header is in the first row.</p>' if spreadsheet.nil?

    header = downcase_array_key spreadsheet.row(1)

    # verify header, raise error if not map
    no_failed_hearders = MOASHeader.verify_header(header, @language)

    return ('<p class = "alert alert-error">Below is the missing header titles list. Please update header title(s) of the excel file || contact your administrator<br/>' << no_failed_hearders.to_s << '</p>') if no_failed_hearders != true
    return ('<p class = "alert alert-error">No data in excel file. Please re-check!</p>') if spreadsheet.last_row <= 1

    # begin transaction
    begin
      connection = Connection.new
      connection.open_connection_in_config
      connection.con.autocommit false

      # 1. DELETE ALL RECORDS
      connection.execute_sql_statement "delete from #{@table}"
      pstmt = connection.con.prepare("insert into #{@table}(golivedate,appstatus,sku,shorttitle,longtitle,gender,agefrommonths,agetomonths,skill,curriculum,longdesc,platformcompatibility,specialmsg,teaches,licenselegal,licnonlic,license,language,pricetier,category,us,ca,uk,ie,au,row,fr_fr,fr_ca,fr_row) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)")
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]

        # 2. INSERT DATA TO DATABASE
        insert_data pstmt, row
      end

      # 3. UPDATE DATA FOR LOCALE
      update_locale connection
      connection.con.commit # commit transaction

      return '<p class = "alert alert-success">MOAS file is imported successfully!</p>'
    rescue  => e
      connection.con.rollback # rollback transaction
      return '<p class = "alert alert-error">PLEASE SELECT CORRECT TABLE. <br/>' << e.message << '</p>'
    ensure
      connection.close_connection if connection
    end # end begin transaction
  end

  # update data from catalog to moas_table
  def update_catalog_to_moas(file)
    spreadsheet = ModelCommon.open_spreadsheet(file)
    return '<p class = "alert alert-error">Please save as the Catalog file to excel format and try again</p>' if spreadsheet.nil?

    header = downcase_array_key spreadsheet.row(1)

    # make sure catalog info in first sheet and header in the first row
    return '<p class = "alert alert-error">
              Make sure that: <br/>
              1. Catalog info is in the first sheet. <br/>
              2. Header is in the first row.
            </p>' unless header.include?('storevisible')

    connection = Connection.new
    connection.open_connection_in_config
    connection.con.autocommit false

    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]

      # UPDATE DATA TO DATABASE
      sql = "UPDATE #{@table} SET storevisible = #{row['storevisible']} WHERE SKU = '#{row['skucode']}'"
      connection.execute_sql_statement sql
    end
    connection.con.commit # commit transaction

    return '<p class="alert alert-success">Imported catalog successfully!</p>'
  rescue => e
    connection.con.rollback # rollback transaction
    return "<p class = 'alert alert-error'>Exception[update catalog file]: #{e.message}"
  end

  # update data from ymal to moas_table
  def update_ymal_to_moas(file)
    spreadsheet = ModelCommon.open_spreadsheet(file)
    return '<p class = "alert alert-error">Please save as the YMAL file to excel format and try again</p>' if spreadsheet.nil?

    header = downcase_array_key spreadsheet.row(1)

    # make sure catalog info in first sheet and header in the first row
    if !header.include?('source sku') || !header.include?('target sku')
      return '<p class = "alert alert-error">
                Make sure that: <br/>
                1. YMAL Catalog info is in the first sheet. <br/>
                2. Header of YMAL catalog info exists \'Source SKU\', \'Target SKU\' in the first row.
              </p>'
    end

    connection = Connection.new
    connection.open_connection_in_config
    connection.con.autocommit false

    temp = []
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      temp << { sku: row['source sku'], ymal: row['target sku'] }
    end

    yaml_array = temp.group_by { |x| x[:sku] }.values
    yaml_array.map! { |x| { sku: x[0][:sku], ymal: x.map { |y| y[:ymal] }.join(',') } }

    yaml_array.each do |el|
      # UPDATE DATA TO DATABASE
      connection.execute_sql_statement "UPDATE #{@table} SET ymal = '#{el[:ymal]}' WHERE SKU = '#{el[:sku]}'"
    end

    connection.con.commit # commit transaction
    return "<p class = 'alert alert-success'>Updated YMAL information successfully!</p>"
  rescue => e
    connection.con.rollback # rollback transaction
    return '<p class = "alert alert-error">' << e.message << '</p>'
  ensure
    connection.close_connection if connection
  end

  # execute insert statement into database by using Prepared Statement
  def insert_data(pstmt, row)
    if @language == 'french'
      pstmt.execute(
        date_default_value(row["#{MOASHeader::HEADERS['GO_LIVE_DATE'].downcase}"]),
        convert_data(row["#{MOASHeader::HEADERS['APP_STATUS'].downcase}"]),
        convert_data(row["#{MOASHeader::HEADERS['SKU'].downcase}"]),
        convert_data(row["#{MOASHeader::HEADERS['SHORT_TITLE'].downcase}"]),
        convert_data(row["#{MOASHeader::HEADERS['LONG_TITLE'].downcase}"]),
        convert_data(row["#{MOASHeader::HEADERS['GENDER'].downcase}"]),
        number_default_value(row["#{MOASHeader::HEADERS['AGE_FROM_MONTHS'].downcase}"]),
        number_default_value(row["#{MOASHeader::HEADERS['AGE_TO_MONTHS'].downcase}"]),
        convert_data(row["#{MOASHeader::HEADERS['SKILL'].downcase}"]),
        convert_data(row["#{MOASHeader::HEADERS['CURRICULUM'].downcase}"]),
        convert_data(row["#{MOASHeader::HEADERS['LONG_DESCRIPTION'].downcase}"]),
        convert_data(row["#{MOASHeader::HEADERS['PLATFORM_COMPATIBILITY_FR'].downcase}"]),
        convert_data(row["#{MOASHeader::HEADERS['SPECIAL_MESSAGE'].downcase}"]),
        convert_data(row["#{MOASHeader::HEADERS['TEACHES_FR'].downcase}"]),
        convert_data(row["#{MOASHeader::HEADERS['LICENSE_LEGAL'].downcase}"]),
        convert_data(row["#{MOASHeader::HEADERS['LICENSE_NON_LICENSE'].downcase}"]),
        convert_data(row["#{MOASHeader::HEADERS['LICENSE'].downcase}"]),
        convert_data(row["#{MOASHeader::HEADERS['LANGUAGE'].downcase}"]),
        convert_data(row["#{MOASHeader::HEADERS['PRICE_TIER'].downcase}"]),
        convert_data(row["#{MOASHeader::HEADERS['CATEGORY'].downcase}"]),
        '',
        '',
        '',
        '',
        '',
        '',
        convert_data(row["#{MOASHeader::HEADERS['FRANCE'].downcase}"]),
        convert_data(row["#{MOASHeader::HEADERS['FRENCH_CANADA'].downcase}"]),
        convert_data(row["#{MOASHeader::HEADERS['FRENCH_ROW'].downcase}"])
      )
    elsif @language == 'english'
      pstmt.execute(
        date_default_value(row["#{MOASHeader::HEADERS['GO_LIVE_DATE'].downcase}"]),
        convert_data(row["#{MOASHeader::HEADERS['APP_STATUS'].downcase}"]),
        convert_data(row["#{MOASHeader::HEADERS['SKU'].downcase}"]),
        convert_data(row["#{MOASHeader::HEADERS['SHORT_TITLE'].downcase}"]),
        convert_data(row["#{MOASHeader::HEADERS['LONG_TITLE'].downcase}"]),
        convert_data(row["#{MOASHeader::HEADERS['GENDER'].downcase}"]),
        number_default_value(row["#{MOASHeader::HEADERS['AGE_FROM_MONTHS'].downcase}"]),
        number_default_value(row["#{MOASHeader::HEADERS['AGE_TO_MONTHS'].downcase}"]),
        convert_data(row["#{MOASHeader::HEADERS['SKILL'].downcase}"]),
        convert_data(row["#{MOASHeader::HEADERS['CURRICULUM'].downcase}"]),
        convert_data(row["#{MOASHeader::HEADERS['LONG_DESCRIPTION'].downcase}"]),
        convert_data(row["#{MOASHeader::HEADERS['PLATFORM_COMPATIBILITY'].downcase}"]),
        convert_data(row["#{MOASHeader::HEADERS['SPECIAL_MESSAGE'].downcase}"]),
        convert_data(row["#{MOASHeader::HEADERS['TEACHES'].downcase}"]),
        convert_data(row["#{MOASHeader::HEADERS['LICENSE_LEGAL'].downcase}"]),
        convert_data(row["#{MOASHeader::HEADERS['LICENSE_NON_LICENSE'].downcase}"]),
        convert_data(row["#{MOASHeader::HEADERS['LICENSE'].downcase}"]),
        convert_data(row["#{MOASHeader::HEADERS['LANGUAGE'].downcase}"]),
        convert_data(row["#{MOASHeader::HEADERS['PRICE_TIER'].downcase}"]),
        convert_data(row["#{MOASHeader::HEADERS['CATEGORY'].downcase}"]),
        convert_data(row["#{MOASHeader::HEADERS['US'].downcase}"]),
        convert_data(row["#{MOASHeader::HEADERS['CA'].downcase}"]),
        convert_data(row["#{MOASHeader::HEADERS['UK'].downcase}"]),
        convert_data(row["#{MOASHeader::HEADERS['IE'].downcase}"]),
        convert_data(row["#{MOASHeader::HEADERS['AU'].downcase}"]),
        convert_data(row["#{MOASHeader::HEADERS['ROW'].downcase}"]),
        '',
        '',
        ''
      )
    end
  end

  # update locale of titles table after insert completely
  def update_locale(connection)
    connection.execute_sql_statement "UPDATE #{@table}
      SET
      lp2 = CASE WHEN platformcompatibility like '%LeapPad2%' THEN 'X' ELSE '' END,
      lp1 = CASE WHEN platformcompatibility like '%LeapPad1%' THEN 'X' ELSE '' END,
      lpu = CASE WHEN platformcompatibility like '%LeapPad Ultra%' THEN 'X' ELSE '' END,
      lex = CASE WHEN platformcompatibility like '%Leapster Explorer%' THEN 'X' ELSE '' END,
      lgs = CASE WHEN platformcompatibility like '%LeapsterGS Explorer%' THEN 'X' ELSE '' END,
      lpr = CASE WHEN platformcompatibility like '%LeapReader%' THEN 'X' ELSE '' END,
      lp3 = CASE WHEN platformcompatibility like '%LeapPad3%' THEN 'X' ELSE '' END
      "
  end

  # return default value for number data type
  def number_default_value(text)
    text.nil? || text == '' ? 0 : text
  end

  # return default value for date data type
  def date_default_value(date)
    date.nil? || date == '' ? '0000-00-00' : date.to_s
  end

  # sanitize data for SQL statement - no need if use prepared statement
  # replace " to \"
  def convert_data(text)
    text.nil? ? '' : text
  end

  # roo lib is case sensitive
  # this method is designed to ignore this issue
  def downcase_array_key(arr)
    arr.map { |i| i.to_s.downcase unless i.nil? }
  end
end

#--------------------------
class MOASHeader
  HEADERS = Hash[
    'GO_LIVE_DATE' => 'Go Live Date',
    'APP_STATUS' => 'App Status',
    'SKU' => 'SKU',
    'SHORT_TITLE' => 'LF Short Name',
    'LONG_TITLE' => 'LF Long Name',
    'GENDER' => 'Gender',
    'AGE_FROM_MONTHS' => 'Age From (Months)',
    'AGE_TO_MONTHS' => 'Age To (Months)',
    'SKILL' => 'Skills',
    'CURRICULUM' => 'Curriculum',
    'LONG_DESCRIPTION' => 'LF Description',
    'PLATFORM_COMPATIBILITY' => 'Platform Compatibility',
    'PLATFORM_COMPATIBILITY_FR' => 'French Platform Compatibility',
    'SPECIAL_MESSAGE' => 'Special Message',
    'TEACHES' => 'Teaches',
    'TEACHES_FR' => 'French Teaches',
    'LICENSE_LEGAL' => 'Legal Bottom',
    'LICENSE_NON_LICENSE' => 'Licensed',
    'LICENSE' => 'Licensors',
    'LANGUAGE' => 'Language',
    'PRICE_TIER' => 'Price Tier',
    'CATEGORY' => 'Content Type',
    'US' => 'EN_US',
    'CA' => 'EN_CA',
    'UK' => 'EN_GB',
    'IE' => 'EN_IE',
    'AU' => 'EN_AU',
    'ROW' => 'EN_ROW',
    'FRANCE' => 'France',
    'FRENCH_CANADA' => 'French Canada',
    'FRENCH_ROW' => 'French ROW']

  # make sure header in MOAS excel file is design
  def self.verify_header(header, language)
    headers_const = []

    HEADERS.each_value do |v|
      headers_const.push(v)
    end

    failed_hearders = headers_const.map(&:downcase) - header.map { |i| i.downcase unless i.nil? }

    # remove French header
    if language == 'english'
      failed_hearders.delete_if { |item| item == HEADERS['TEACHES_FR'].downcase || item == HEADERS['PLATFORM_COMPATIBILITY_FR'].downcase || item == HEADERS['FRANCE'].downcase || item == HEADERS['FRENCH_CANADA'].downcase || item == HEADERS['FRENCH_ROW'].downcase }
    elsif language == 'french'
      failed_hearders.delete_if { |item| item == HEADERS['TEACHES'].downcase || item == HEADERS['PLATFORM_COMPATIBILITY'].downcase || item == HEADERS['US'].downcase || item == HEADERS['CA'].downcase || item == HEADERS['UK'].downcase || item == HEADERS['AU'].downcase || item == HEADERS['IE'].downcase || item == HEADERS['ROW'].downcase }
    end

    if failed_hearders.to_s == '[]'
      return true
    else
      return failed_hearders
    end
  end
end
