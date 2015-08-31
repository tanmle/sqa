require File.expand_path('../../spec_helper', __FILE__)
require 'product_checking_negative_common'
require 'connection'
require 'dataconvert'

=begin
EP English: Fill by Skill and verify that apps which does not belong to current Skill should be not displayed
=end

# Initiate DataConvert instance
data = DataConvert.convert_skill

# Get test driver data
testdriver = Connection.my_sql_connection(SQLTestDriverConst::CONST_SQL_SKILL)

# Run test script
verify_product_information_negative testdriver, TestProductType::CONST_SKILL
