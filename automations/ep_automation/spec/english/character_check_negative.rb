require File.expand_path('../../spec_helper', __FILE__)
require 'product_checking_negative_common'
require 'dataconvert'
require 'connection'

=begin
EP English: Fill by Character and verify that apps which does not belong to current characters should be not displayed
=end

# Get test driver data
testdriver = Connection.my_sql_connection(SQLTestDriverConst::CONST_SQL_CHARACTER)

# Run test script
verify_product_information_negative testdriver, TestProductType::CONST_CHARACTER
