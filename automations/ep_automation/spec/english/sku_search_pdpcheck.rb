require File.expand_path('../../spec_helper', __FILE__)
require 'search_checking_common'
require 'connection'

=begin
EP English: Search app and check information on Catalog + PDP page for all storefronts
=end

verify_search_pdp TestDriver::CONST_LOCALES, TestDriver::CONST_STOREFRONTS
