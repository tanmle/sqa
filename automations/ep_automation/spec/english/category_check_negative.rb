require File.expand_path('../../spec_helper', __FILE__)
require 'product_checking_negative_common'
require 'dataconvert'
require 'connection'

=begin
EP English: Fill by Category and verify that apps which does not belong to current category should be not displayed
=end

# prepair data
DataConvert.convert_category

# Get test driver data
testdriver = Connection.my_sql_connection(SQLTestDriverConst::CONST_SQL_CATEGORY)

# Run test script
verify_product_information_negative testdriver, TestProductType::CONST_CATEGORY
