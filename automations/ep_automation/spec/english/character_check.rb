require File.expand_path('../../spec_helper', __FILE__)
require 'product_checking_common'
require 'connection'

=begin
EP English: Fill by Character and check app information on Catalog page for all storefronts
=end

# Get test driver data
testdriver = Connection.my_sql_connection(SQLTestDriverConst::CONST_SQL_CHARACTER)

# Run test script
verify_product_information testdriver, TestProductType::CONST_CHARACTER
