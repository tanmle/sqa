require 'pages/atg_dv/atg_dv_common_page'
require 'pages/atg_dv/atg_dv_check_out_page'

class DvTopNavigation < SitePrism::Section
  element :search_btn, '.icon-nav.icon-search'
  element :wishlist_link, '.icon-nav.icon-wishlist'
  element :cart_link, '.icon-nav.icon-cart'
  element :wishlist_item_number, '.icon-nav.icon-wishlist .badge.badge-nav.ng-binding'
  element :cart_item_number, '.icon-nav.icon-cart .badge.badge-nav.ng-binding'
end

class AtgDvAppCenterPage < AtgDvCommonPage
  set_url URL::ATG_DV_APP_CENTER_URL

  section :dv_top_navigation, DvTopNavigation, '.navbar.navbar-fixed-top'
  element :catalog_div_css, '.container.no-pad.ng-scope'
  elements :product_list, '.col-xs-12.col-sm-4 > div'

  def load
    visit url
    visit url unless has_catalog_div_css?(wait: TimeOut::WAIT_CONTROL_CONST)
    TestDriverManager.session_id
  end

  def dv_get_random_product_id(duplicate_item = nil)
    arr_id = []
    product_list.each do |product|
      arr_id.push(product['id'])
    end

    arr_id.delete(duplicate_item) unless duplicate_item.nil?

    return arr_id[rand(arr_id.count - 1)] if arr_id.count < 6
    arr_id[rand(6)]
  end

  def dv_get_random_product_info(duplicate_item = nil)
    product_id = dv_get_random_product_id duplicate_item
    product_html = Nokogiri::HTML(page.evaluate_script("$('.container.no-pad.ng-scope').parent().html();").to_s)

    product_el = product_html.css(".col-xs-12.col-sm-4 > ##{product_id.downcase}")
    return {} if product_el.empty?

    sku = product_el.css('div>@data-ga-prod-childskus').to_s
    title = product_el.css('.col-xs-12>h2').text.delete("\n")

    # Get price
    strike = product_el.css('.price.strike').text.delete("\n")
    sale = product_el.css('.price.sale').text.delete("\n")
    price = strike.blank? ? product_el.css('.price').text.delete("\n") : ''

    { product_id: product_id, sku: sku, title: title, price: price, strike: strike, sale: sale }
  end

  def dv_add_to_cart_from_catalog(product_id)
    find(:xpath, "(.//div[@id='#{product_id}']//button[contains(text(),'Add to Cart')])[1]").click
    page.has_xpath?("(.//div[@id='#{product_id}']//button[contains(text(),'Added to Cart')])[1]")
  end

  def dv_go_to_check_out_page
    dv_top_navigation.cart_link.click
    AtgDvCheckOutPage.new
  end
end
