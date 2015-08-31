require File.expand_path('../../spec_helper', __FILE__)
require 'ymal_checking_common'
require 'connection'

=begin
Check YMAL information on PDP page
=end

verify_ymal TestDriver::CONST_LOCALES, TestDriver::CONST_STOREFRONTS
