require 'const'
require 'mysql'

# This class initiate connection to MySql and execute queries
class Connection
  attr_accessor :con
  
  def self.my_sql_connection(querystring)
    # Initiate connection to mysql database
    con = Mysql.new MySQLConst::CONST_SERVER, MySQLConst::CONST_USERNAME, MySQLConst::CONST_PASSOWRD, MySQLConst::CONST_DATABASE, MySQLConst::CONST_PORT

    # Excute query to get categories for French page
    rs = con.query querystring

    # Close connection
    con.close

    return rs
  end

  def open_connection
    # Initiate connection to mysql database
    @con = Mysql.new MySQLConst::CONST_SERVER, MySQLConst::CONST_USERNAME, MySQLConst::CONST_PASSOWRD, MySQLConst::CONST_DATABASE, MySQLConst::CONST_PORT
  end

  def execute_sql_statement(statement)
    # Excute statement
    @con.query statement
  end

  def close_connection
    # Close connection
    @con.close if @con
  end

end
