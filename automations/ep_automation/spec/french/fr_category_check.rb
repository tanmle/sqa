require File.expand_path('../../spec_helper', __FILE__)
require 'product_checking_common'
require 'dataconvert'
require 'connection'

=begin
EP French: Fill by Category and check app information on Catalog page for all storefronts
=end

# Handle cases that data is incorrect
DataConvert.convert_category false

# Get test driver data
testdriver = Connection.my_sql_connection(SQLTestDriverConst::CONST_SQL_CATEGORY_FR)

# Run test script
verify_product_information testdriver, TestProductType::CONST_CATEGORY, false
