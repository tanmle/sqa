=begin
CS checking content automation
=end

require File.expand_path('../../spec_helper', __FILE__)
require 'cs_checking_common'
require 'connection'

verify_cs_checking TestDriver::CONST_LOCALES, TestDriver::CONST_STOREFRONTS, CSCode::CONST_CSCODE
