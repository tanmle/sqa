require File.expand_path('../../spec_helper', __FILE__)
require 'product_checking_negative_common'
require 'dataconvert'
require 'connection'

=begin
EP French: Fill by Category and verify that apps which does not belong to current category should be not displayed
=end

# Handle cases that data is incorrect
DataConvert.convert_category false

# Get test driver data
testdriver = Connection.my_sql_connection(SQLTestDriverConst::CONST_SQL_CATEGORY_FR)

# Run test script
verify_product_information_negative testdriver, TestProductType::CONST_CATEGORY, false
