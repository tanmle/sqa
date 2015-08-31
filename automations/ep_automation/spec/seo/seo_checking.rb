require File.expand_path('../../spec_helper', __FILE__)
require 'seo_checking_common'
require 'capybara'

=begin
Check SEO url, title, description on PDP page for US locales and all storefront
=end

# Currently we just check US & all stores
ep_verify_seo_url_title_des LocalesConst::CONST_US, TestDriver::CONST_STOREFRONTS
