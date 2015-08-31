require File.expand_path('../../spec_helper', __FILE__)
require 'search_checking_negative_common'

=begin
EP French: Search app and verify that apps which does not belong to current locales shouldn't displayed
=end

verify_skus_are_not_on_locale_storefront TestDriver::CONST_LOCALES_FR, TestDriver::CONST_STOREFRONTS_FR, false