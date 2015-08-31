require File.expand_path('../../spec_helper', __FILE__)
require 'product_checking_common'
require 'dataconvert'
require 'connection'

=begin
EP English: Fill by Category and check app information on Catalog page for all storefronts
=end

# Prepair data
DataConvert.convert_category

# Get test driver data
testdriver = Connection.my_sql_connection(SQLTestDriverConst::CONST_SQL_CATEGORY)

# Run test script
verify_product_information testdriver, TestProductType::CONST_CATEGORY
