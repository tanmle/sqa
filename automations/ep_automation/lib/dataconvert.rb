require 'const'
require 'connection'

# This class is to convert data from tables to corresponding appcenter data on page
# Created date: 1/7/2014
class DataConvert
  # This method is to change storefront for English/French page
  def self.storefront(text, english = true)
    case text
    when 'leappad'
      text = english ? StorefrontConst::CONST_STOREFRONT_LP : StorefrontConst::CONST_STOREFRONT_LP_FR
    when 'leapster'
      text = english ? StorefrontConst::CONST_STOREFRONT_LE : StorefrontConst::CONST_STOREFRONT_LE_FR
    when 'leapreader'
      text = StorefrontConst::CONST_STOREFRONT_LR
    end
    text
  end

  def self.character_string(character)
    case character
    when 'Disney Sofia the First'
      character = 'Sofia'
    when 'Wallace & Gromit'
      character = 'Wallace'
    when 'Thomas & Friends'
      character = 'Thomas'
    when 'Jake & the Never Land Pirates'
      character = 'Jake'
    when 'Jake & the Neverland Pirates'
      character = 'Jake'
    when 'The Hive'
      character = 'Hive'
    when 'Disney Cars'
      character = 'Cars'
    when 'Disney Planes'
      character = 'Planes'
    when 'Disney Princesses'
      character = 'Disney Princess'
    when 'Dora the Explorer'
      character = 'Dora'
    when 'Disney Cars'
      character = 'Cars 2'
    when 'Leap School'
      character = 'LeapSchool'
    when 'Mr. Pencil'
      character = 'Pencil'
    when 'Disney Frozen'
      character = 'Frozen'
    end
    character
  end

  def self.convert_category(english = true)
    # prepair data
    connection = Connection.new
    connection.open_connection
    if english
      connection.execute_sql_statement("update #{TableName::CONST_TITLE_TABLE} set category='Learning Videos' where category IN ('video', 'videos', 'Learning Video')")
      connection.execute_sql_statement("update #{TableName::CONST_TITLE_TABLE} set category='Games' where category IN ('game', 'Learning Games', 'Learning Game')")
      connection.execute_sql_statement("update #{TableName::CONST_TITLE_TABLE} set category='eBooks' where category = 'eBook'")
      connection.execute_sql_statement("update #{TableName::CONST_TITLE_TABLE} set category='Audio Books' where category = 'Audio Book'")
      connection.execute_sql_statement("update #{TableName::CONST_TITLE_TABLE} set category='Interactive Storybooks' where category = 'Ultra eBook'")
      connection.execute_sql_statement("update #{TableName::CONST_TITLE_TABLE} set category='Just for Fun' where category = 'Utility'")
    else
      connection.execute_sql_statement("update #{TableName::CONST_TITLE_FR} set category = 'Vidéos' where category = 'Vidéo'")
      connection.execute_sql_statement("update #{TableName::CONST_TITLE_FR} set category = 'e-Livres' where category = 'Ultra e-Livres'")
      connection.execute_sql_statement("update #{TableName::CONST_TITLE_FR} set category = 'Musique et créativité' where category = 'Musique & Créativité' or category = 'Créativité'")
      end
    connection.close_connection
  end

  def self.convert_skill
    Connection.my_sql_connection("update #{TableName::CONST_TITLE_TABLE} set skill='Science & Social Studies' where skill = 'Science'")
  end

  # use for French suites
  def self.convert_english_to_french(field_name, eng_valaue)
    val = nil
    begin
      connection = Connection.new
      connection.open_connection
      val = connection.execute_sql_statement("select french from ep_moas_fr_mapping where field_name = '#{field_name}' and english = '#{eng_valaue}' LIMIT 1").fetch_hash['french']
      connection.close_connection
    rescue => e
      e
    end

    (val.nil?) ? eng_valaue : val
  end

  # use for French suites
  def self.convert_french_to_english(field_name, fre_valaue)
    val = nil
    begin
      connection = Connection.new
      connection.open_connection
      val = connection.execute_sql_statement("select english from ep_moas_fr_mapping where field_name = '#{field_name}' and french = '#{fre_valaue}' LIMIT 1").fetch_hash['english']
      connection.close_connection
    rescue => e
      e
    end

    (val.nil?) ? fre_valaue : val
  end
end
