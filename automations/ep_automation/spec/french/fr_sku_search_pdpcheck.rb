require File.expand_path('../../spec_helper', __FILE__)
require 'search_checking_common'
require 'connection'

=begin
EP French: Search app and check information on Catalog + PDP page for all storefronts
=end

verify_search_pdp TestDriver::CONST_LOCALES_FR, TestDriver::CONST_STOREFRONTS_FR, false
