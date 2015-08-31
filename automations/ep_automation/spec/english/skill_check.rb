require File.expand_path('../../spec_helper', __FILE__)
require 'product_checking_common'
require 'connection'
require 'dataconvert'

=begin
EP English: Fill by Skill and check app information on Catalog page for all storefronts
=end

# prepair data
DataConvert.convert_skill

# Get test driver data
testdriver = Connection.my_sql_connection(SQLTestDriverConst::CONST_SQL_SKILL)

# Run test script
verify_product_information testdriver, TestProductType::CONST_SKILL
