require 'pages/atg/atg_common_page'
require 'pages/atg/atg_app_center_checkout_page'

class QuickViewSection < SitePrism::Section
  element :long_name_txt, '#productQuickview h2>a'
  element :ages_txt, '.span6.description.qv-description-block .ageDisplay'
  element :description_txt, '.span6.description.qv-description-block>p:nth-of-type(2)'
  element :description_h1, :xpath, "//h3[contains(text(),'Description')]"
  element :teaches_h1, :xpath, "//h3[contains(text(),'Teaches')]"
  element :workswith_h1, :xpath, "//h3[contains(text(),'Works With:')]"
  element :see_detail_link_txt, '.span6.description.qv-description-block a'
  element :price_txt, '.single.price'
  element :strike_price_txt, '.single.price.strike'
  element :add_to_cart, '.qv-add-to-cart *[type="submit"]'
  element :add_to_wishlist_lnk, '.wishlist-link>a'
  element :small_icon_img, :xpath, ".//*[@class = 'hardgood-sku' or @class = 'softgood-sku']/img"
  element :large_icon_img, :xpath, "//*[@class = 'video-container' or @class = 'row rollover-top']/img" # video or image
end

class NavAccountMenu < SitePrism::Section
  element :login_register_link, '#headerLogin'
  element :shop_cart_link, '.nav-account__mini-cart-hardgoods-link'
  element :appcenter_cart_link, '.nav-account__mini-cart-softgoods-link'
  element :logout_link, '#atg_logoutBtn'
  element :login_link, '#atg_loginBtn'
  element :checkout_btn, '#miniCartCheckoutBtn'
  element :app_center_item_number, :xpath, ".//*[@id='navAccount']//a[@class='nav-account__mini-cart-softgoods-link']/span"
end

class AppCenterCatalogATG < CommonATG
  #
  # Set url of home page, is also catalog page
  #
  set_url URL::ATG_CONST

  # Set property
  attr_reader :catalog_div_css

  def initialize
    @catalog_div_css = '.resultList .product-row'
  end

  # Set element for PDP page
  elements :product_list_div, :xpath, "//div[@class='resultList']//div[@class='catalog-product blk blk-l' or @class='catalog-product']/div"
  element :product_detail_div, '#productDetails'
  element :long_name_txt, 'h1.product-name'
  element :write_a_review_div, '.BVRRRatingSummary.BVRRPrimarySummary.BVRRPrimaryRatingSummary' # The 'Write a review' box under long name
  element :age_txt, 'span.pdp-age-mo'
  element :description_txt, '.description'
  elements :attributes_div, 'div.attributes>p'
  element :moreinfo_lb, '.credits-link' # With Music, Audio Books apps, it is Credit link. With other apps, it is More info label
  element :moreinfo_txt, '#credits' # With Music, Audio Books apps, it is Credit text. With other apps, it is More info text
  element :special_message_txt, '.special-message'
  element :legal_top_txt, '.legal-top'
  element :legal_bottom_txt, :xpath, ".//*[@id='sectionContainer']/div[@class = 'legal-bottom section']/div[@class = 'container']"
  element :price_txt, '#productDetails .single.price'
  element :strike_price_txt, '#productDetails .single.price.strike'
  element :add_to_cart_btn, :xpath, "(//*[contains(@value,'Add to Cart') or contains(text(), 'Add to Cart')])[1]" # add to cart button on PDP
  element :add_to_cart_on_search_btn, :xpath, "(.//button[@class='btn btn-add-to-cart btn-block ng-isolate-scope'])[1]" # add to cart button of item on search page
  element :buy_now_btn, '#sub-nav-grnbar-btn', visible: false
  element :add_to_wishlist_lnk, '#productDetails .wishlist-link>a'
  element :show_more_lnk, '#showBtn a' # If have more than 3 details, this link will be displayed
  elements :details_txt, 'div.detail-2col-dflt' # details include detail title and detail text
  elements :teaches_txt, '.span3.skills-container>ul>li' # Skills list
  element :learning_difference_txt, '.span9.teaches-media>p'
  element :trailer_box, '.video' # Trailer video box
  element :review_box, :xpath, ".//*[@id='Reviews']/div[@class='container']/div[@class='row heading']/h2"
  element :credits_lnk, '.details-credits>div>a'
  element :credits_app_title_txt, '.richtext.section>p:first-of-type'
  element :more_like_this, :xpath, ".//*[@id='MoreLikeThis']/div[@class='container']"
  elements :footer_div, :xpath, "//*[@id = 'footer' or @class='legal-bottom' or @id = 'MoreLikeThis' or @id = 'Reviews' or @id = 'Teaches']"

  # quick view section
  section :quick_view_info, QuickViewSection, '#productQuickview'
  section :nav_account_menu, NavAccountMenu, '.navbar-inner'

  #
  # Methods
  #
  def load(url)
    visit url
    wait_for_ajax
  end

  # This click goes to PDP of found title after searching
  def go_pdp(sku)
    page.find(:xpath, "(.//*[contains(@id, '#{sku}')]/div/p/a)[1]", wait: TimeOut::WAIT_MID_CONST).click
    wait_for_ajax

    AppCenterCatalogATG.new
  end

  #
  # Get html code on Page
  #
  def generate_product_html
    wait_for_ajax
    str = page.evaluate_script("$(\"#{@catalog_div_css}\").parent().html();")
    Nokogiri::HTML(str.to_s)
  end

  #
  # get html of all catalog product in catalog page
  # all catalog in div with class: ".product-row.row.blk"
  # This returns array of hashes {:id => id, :title => title, :href => href, :price => price} that information of each product
  #
  def get_product_info(html_doc, product_id)
    product_el = html_doc.css("##{product_id}")
    return {} if product_el.empty?

    id = product_el.css('div > @id').to_s
    longname = product_el.css('div > div.product-inner > p > a').text
    href = product_el.css('div > div.product-inner > p > a > @href').to_s
    content_type = product_el.css('div > div.product-inner > div.product-thumb.has-content > @data-content').to_s
    format = product_el.css('div > div.product-inner p.format-type').text
    age = RspecEncode.remove_nbsp(product_el.css('div > div.product-inner p.ageDisplay').text.strip)

    # Get Price
    price = product_el.css('div > div.product-inner p.prices > span.single.price.strike').text
    price = product_el.css('div > div.product-inner p.prices > span.single.price').text if price.blank?

    { id: id, longname: longname, href: href, price: price, content_type: content_type, format: format, age: age }
  end

  # @return Boolean
  def product_not_exist?(html_doc, product_id)
    html_doc.css("##{product_id}").empty?
  end

  #
  # Get status of Trailer is exist or not exist
  #
  def trailer?
    has_trailer_box?
  end

  # Get detail title/text
  def get_detail
    details = [title: '', text: '']
    detail_title = ''
    detail_text = ''

    if has_show_more_lnk?
      # Click on Show more link
      page.execute_script("$('#showBtn a').click();")
      sleep 2
    end

    # detail-content
    if has_details_txt?
      details_txt.each do |detail|
        within detail do
          detail_title = find('h4').text
          detail_text = RspecEncode.process_long_desc find('p').text
        end
        details.push title: detail_title, text: detail_text
      end
    elsif has_css? '.detail-content', wait: 0
      detail_title = page.find('.detail-content > h4').text
      detail_text = RspecEncode.process_long_desc page.find('.detail-content > p').text
      details.push title: detail_title, text: detail_text
    end

    details
  end

  #
  # Get more info label/text
  #
  def get_more_info
    div_css = '#productDetails'
    str = page.evaluate_script("$(\"#{div_css}\").parent().html();")
    html_doc = Nokogiri::HTML(str.gsub('<br>', ' '))

    # Get more info label
    moreinfo_lb = html_doc.css('.credits-link>.text').text

    # Get more info text
    moreinfo_txt = html_doc.css('#credits').text

    { moreinfo_lb: moreinfo_lb, moreinfo_txt: moreinfo_txt }
  end

  #
  # get information on product details page for testing
  # this return hash that includes information for testing
  #
  def get_pdp_info
    wait_for_product_detail_div(TimeOut::WAIT_BIG_CONST * 2)

    # Get information on pdp page
    long_name = long_name_txt.text
    age = RspecEncode.remove_nbsp(age_txt.text.strip)
    description = description_txt.text
    moreinfo_lb = get_more_info[:moreinfo_lb].gsub("\n", '').gsub(/\s+/, ' ') # Remove '\n' and double space characters
    moreinfo_text = get_more_info[:moreinfo_txt].gsub("\n", '').gsub(/\s+/, ' ')
    special_message = (has_special_message_txt?) ? special_message_txt.text : '' # If special message exist => return special text. Else, return ''
    legal_top = (has_legal_top_txt?) ? legal_top_txt.text : ''
    legal_bottom = (has_legal_bottom_txt?) ? legal_bottom_txt.text : ''
    learning_difference = (has_learning_difference_txt?(wait: TimeOut::WAIT_SMALL_CONST)) ? learning_difference_txt.text : ''
    review = has_review_box? # If Review box exist ->'true' else 'false'
    more_like_this = has_more_like_this? # If More Like this box exist ->'true' else 'false'
    write_a_review = has_write_a_review_div?(wait: TimeOut::WAIT_SMALL_CONST) # If 'Write a Review' box exist ->'true' else 'false'
    add_to_wishlist = has_add_to_wishlist_lnk? # If 'Add to Wishlist' button exist -> 'true' else 'false'

    # Get price:
    if has_strike_price_txt?(wait: TimeOut::WAIT_SMALL_CONST)
      price = strike_price_txt.text
    else
      price = (has_price_txt?(wait: TimeOut::WAIT_SMALL_CONST)) ? price_txt.text : ''
    end

    # Get attributes info
    content_type = ''
    curriculum = ''
    notable = ''
    work_with = ''
    publisher = ''
    size = ''
    attributes_div.each do |a|
      attr = a.text.split(':')
      content_type = attr[1].strip if attr[0].include?('Type')
      curriculum = attr[1].strip if attr[0].include?('Curriculum')
      notable = attr[1..-1].join(':').strip if attr[0].include?('Notable')
      work_with = attr[1].gsub(', ', ',').strip if attr[0].include?('Works With')
      publisher = attr[1].strip if attr[0].include?('Publisher')
      size = attr[1].strip if attr[0].include?('Size')
    end

    # Get trailer
    has_trailer = trailer?
    trailer_link = ''
    trailer_link = find('.video')['data-largeimage'].to_s.gsub('"', '\"') if has_trailer_box?

    # Get teaches (Skills list)
    teaches = []
    teaches_txt.each do |teach|
      teaches.push(teach.text)
    end

    # Get product detail
    details = get_detail

    # get value of Add to Cart button: Add to Cart
    add_to_cart_val = ''

    if has_add_to_cart_btn?(wait: 0)
      add_to_cart_val = find(:xpath, "(//input[contains(@value,'Add to Cart')])[1]")[:value] if has_xpath?("//input[contains(@value,'Add to Cart')]", wait: 0)
      add_to_cart_val = find(:xpath, "(//*[contains(text(),'Add to Cart')])[1]").text if has_xpath?("(//*[contains(text(),'Add to Cart')])[1]", wait: 0)
    else
      add_to_cart_val = 'Not Available'
    end

    # get value of buy now button: Buy Now
    buy_now_btn = ''
    execute_script("$('#sub-nav-grnbar-btn').css('display', 'block');")
    buy_now_btn = find('#sub-nav-grnbar-btn')[:value] if has_css?('#sub-nav-grnbar-btn', wait: 0)

    has_credits_link = has_credits_lnk?

    # Put all info into array
    { long_name: long_name,
      age: age,
      description: description,
      content_type: content_type,
      curriculum: curriculum,
      notable: notable,
      work_with: work_with,
      publisher: publisher,
      size: size,
      moreinfo_lb: moreinfo_lb,
      moreinfo_txt: moreinfo_text,
      special_message: special_message,
      legal_top: legal_top,
      price: price,
      details: details,
      learning_difference: learning_difference,
      legal_bottom: legal_bottom,
      teaches: teaches,
      has_trailer: has_trailer,
      trailer_link: trailer_link,
      has_credits_link: has_credits_link,
      review: review,
      more_like_this: more_like_this,
      write_a_review: write_a_review,
      add_to_wishlist: add_to_wishlist,
      add_to_cart_btn: add_to_cart_val,
      buy_now_btn: buy_now_btn }
  end

  #
  # Quick view by prod number
  # Return description if have
  #
  def quick_view_product_by_prodnumber(prodnumber)
    wait_for_ajax
    quick_link_css = ".catalog-product \##{prodnumber} .quick-view.btn.btn-green.btn-small"

    # Visible Quick link by make style 'display' = 'block'
    execute_script("$('#{quick_link_css}').css('display', 'block');")

    find(quick_link_css).click
    wait_for_ajax
  end

  #
  # get information of product on Quick View pop up
  # return hash that consist of product information
  # param: product sku
  #
  def get_quick_view_info(prodnumber)
    quick_view_product_by_prodnumber prodnumber

    # get long name of product on QUickView
    long_name = quick_view_info.long_name_txt.text

    # get ages
    ages = quick_view_info.ages_txt.text

    # get description header: Description
    description_header = quick_view_info.description_h1.text

    # get description text
    description = quick_view_info.description_txt.text

    # get teaches header: Teaches
    teaches_header = (quick_view_info.has_teaches_h1?) ? quick_view_info.teaches_h1.text : ''

    # get works with header: Works With:
    workswith_header = quick_view_info.workswith_h1.text

    # get description block, we need to separate description, teaches and workswith
    desc_mix = find('.span6.description.qv-description-block').text

    if teaches_header.blank?
      sec1 = desc_mix.split('Works With:')
      teaches = ''
    else
      sec1 = desc_mix.split('Teaches:')[1].split('Works With:')
      teaches = sec1[0].strip
    end

    # get works with info
    workswith = sec1[1].gsub('See Details >', '').strip

    # get text of see detail link
    see_detail_link = quick_view_info.see_detail_link_txt.text

    # Get price:
    if quick_view_info.has_strike_price_txt?
      price = quick_view_info.strike_price_txt.text
    elsif quick_view_info.has_price_txt?
      price = quick_view_info.price_txt.text
    else
      price = ''
    end

    # get value of add to cart button
    add_to_cart = quick_view_info.has_add_to_cart? ? quick_view_info.add_to_cart[:value] : 'Not Available'

    # get text of add to wishlist link
    add_to_wishlist = quick_view_info.add_to_wishlist_lnk.text

    # get size of small icon [height, width]
    # with selenium web driver, we can use below command to get height, width
    # small_icon_size = [quick_view_info.small_icon_img[:naturalHeight], quick_view_info.small_icon_img[:naturalWidth]]
    # howerver, webkit web driver cannot understand that command, so we use javascript to get height and width for both selenium and webkit
    if has_css?('.hardgood-sku>img', wait: 1)
      s_height = page.evaluate_script("$('.hardgood-sku>img')[0].naturalHeight")
      s_width = page.evaluate_script("$('.hardgood-sku>img')[0].naturalWidth")
    else
      s_height = page.evaluate_script("$('.softgood-sku>img')[0].naturalHeight")
      s_width = page.evaluate_script("$('.softgood-sku>img')[0].naturalWidth")
    end
    small_icon_size = %W(#{s_height} #{s_width})

    # get size of large icon [height, width]
    # large_icon_size = [quick_view_info.large_icon_img[:naturalHeight], quick_view_info.large_icon_img[:naturalWidth]]
    if has_css?('.video-container>img', wait: 1)
      l_height = page.evaluate_script("$('.video-container>img')[0].naturalHeight")
      l_width = page.evaluate_script("$('.video-container>img')[0].naturalWidth")
    else
      l_height = page.evaluate_script("$('.row.rollover-top>img')[0].naturalHeight")
      l_width = page.evaluate_script("$('.row.rollover-top>img')[0].naturalWidth")
    end
    large_icon_size = %W(#{l_height} #{l_width})

    { long_name: long_name,
      ages: ages,
      description_header: description_header,
      description: description,
      teaches_header: teaches_header,
      teaches: teaches,
      workswith_header: workswith_header,
      workswith: workswith,
      see_detail_link: see_detail_link,
      price: price,
      add_to_cart: add_to_cart,
      add_to_wishlist: add_to_wishlist,
      small_icon_size: small_icon_size,
      large_icon_size: large_icon_size }
  end

  #
  # Get YMAL information on PDP page
  #
  def get_ymal_info_on_pdp
    ymal_arr = []

    # get element
    return ymal_arr unless page.has_css?('.reccommended', wait: 30)
    str = page.evaluate_script("$('.reccommended').html();")

    # convert string element to html element
    html_doc = Nokogiri::HTML(str)

    # get all information of product
    html_doc.css('.catalog-product').each do |el|
      prod_number = el.css('div > @id').to_s
      title = el.css('div>div.product-inner>p>a> @title').to_s.strip
      link = el.css('div>div.product-inner>p>a> @href').to_s

      # Put all info into array
      ymal_arr.push(prod_number: prod_number, title: title, link: link)
    end

    ymal_arr
  end

  #
  # Return true if e_arr and a_arr there is at least one same element
  #
  def two_platforms_compare?(e_platform, a_platform)
    e_arr = e_platform.split(',')
    a_arr = a_platform.split(',')
    !(e_arr & a_arr).empty?
  end

  #
  # add sku to cart
  # return app center check out page
  #
  def add_sku_to_cart(go_to_cart = true)
    add_to_cart_on_search_btn.click
    wait_for_ajax

    return unless go_to_cart
    nav_account_menu.appcenter_cart_link.click
    wait_for_ajax

    AppCenterCheckOutATG.new
  end

  #
  # Use for Soft Good Smoke Test
  # Get random a product id from Catalog page
  #
  def sg_get_random_product_id(duplicate_item = nil)
    arr_id = []

    # get all id of product on catalog page
    product_list_div.each do |product|
      arr_id.push(product['id'])
    end

    # Remove duplicate items
    arr_id.delete(duplicate_item) unless duplicate_item.nil?

    # return random product id
    arr_id[rand(arr_id.count - 1)]
  end

  def get_random_pro_greater_acc_balance(account_balance)
    return [] unless page.has_css?('.resultList .row.raised')

    str = page.evaluate_script("$('.resultList .row.raised').html();")
    html_doc = Nokogiri::HTML(str)

    product_arr = []
    html_doc.css('.catalog-product').each do |el|
      strike = price = nil
      prod_id = el.css('div > @id').text
      title = el.css('p.heading > a').text
      sale = el.css('.single.price.sale').text.strip
      if sale.empty?
        price = el.css('.single.price').text.strip
        product_arr.push(prod_id: prod_id, title: title, price: price, strike: strike, sale: sale) if price.delete('$').to_f > account_balance
      else
        strike = el.css('.single.price.strike').text.strip
        product_arr.push(prod_id: prod_id, title: title, price: price, strike: strike, sale: sale) if sale.delete('$').to_f > account_balance
      end
    end

    product_arr[rand(product_arr.count - 1)]
  end

  def sg_get_sku(prod_id)
    product = find(:xpath, "(//div[@class='catalog-product']/div[@id='#{prod_id}'])[1]")
    skus_arr = product['data-ga-prod-childskus'].split(',')
    skus_arr.each do |sku|
      return sku if sku.length == 11
    end

    ''
  end

  #
  # using for Soft Good
  # Get random a product info
  #

  def sg_get_random_product_info(duplicate_item = nil)
    id = sg_get_random_product_id duplicate_item
    sku = sg_get_sku id
    title = find(:xpath, "(//div[@class='resultList']//*[@id='#{id}']/div/p/a)[1]").text

    price, sale, strike = nil
    if has_xpath?("(//*[@id='#{id}']//span[@class='single price'])[1]", wait: 1)
      price = find(:xpath, "(//*[@id='#{id}']//span[@class='single price'])[1]").text
    else
      strike = find(:xpath, "(//*[@id='#{id}']//span[@class='single price strike'])[1]").text
      sale = find(:xpath, "(//*[@id='#{id}']//span[@class='single price sale'])[1]").text
    end

    { id: id, sku: sku, title: title, price: price, strike: strike, sale: sale }
  end

  #
  # Using for Soft Good
  # Go to App Center check out page
  #
  def sg_go_to_check_out
    # Click on App Center link
    nav_account_menu.appcenter_cart_link.click
    wait_for_ajax

    nav_account_menu.appcenter_cart_link.click if nav_account_menu.app_center_item_number.text.to_i == 0

    AppCenterCheckOutATG.new
  end

  #
  # Add a product to Cart from catalog page by clicking on 'Add to Cart' button
  #
  def add_to_cart_from_catalog(prod_id)
    item_num1 = nav_account_menu.app_center_item_number.text.to_i
    item_num2 = nil

    # Workaround to make script stable by trying to click on Add to Cart button
    btn_add_to_card = find(:xpath, "(.//*[@id='#{prod_id}']//button[@class='btn btn-add-to-cart btn-block ng-isolate-scope'])[1]")
    (1..5).each do
      btn_add_to_card.click
      sleep 1
      item_num2 = nav_account_menu.app_center_item_number.text.to_i
      break if item_num1 < item_num2
    end

    item_num1 < item_num2
  end

  def get_expected_product_info_search_page(title)
    { sku: title['sku'],
      prod_number: title['prodnumber'],
      short_name: RspecEncode.encode_title(title['shortname']),
      long_name: RspecEncode.encode_title(title['longname']),
      price: Title.calculate_price(title['pricetier'], AppCenterContent::CONST_PRICE_TIER),
      content_type: Title.map_content_type(title['contenttype']),
      format: title['format'],
      age: Title.calculate_age_web(title['agefrommonths'], title['agetomonths']) }
  end

  def get_expected_product_info_pdp_page(title)
    details = Title.get_details(title['details']).drop(1) # e_detail[1][:detail_title] to get detailtitle1
    details.map! { |x| { title: x[:title], text: RspecEncode.process_long_desc(x[:text]) } }

    { sku: title['sku'],
      prod_number: title['prodnumber'],
      short_name: RspecEncode.encode_title(title['shortname']),
      long_name: RspecEncode.encode_title(title['longname']),
      description: RspecEncode.process_long_desc(title['lfdesc']),
      one_sentence: RspecEncode.process_long_desc(title['onesentence']),
      age: Title.calculate_age_web(title['agefrommonths'], title['agetomonths'], 'pdp'),
      content_type: Title.map_content_type(title['contenttype']),
      format: title['format'],
      price: Title.calculate_price(title['pricetier'], AppCenterContent::CONST_PRICE_TIER),
      curriculum: title['curriculum'],
      work_with: Title.replace_epic_platform(title['platformcompatibility'].split(',')),
      publisher: title['publisher'],
      filesize: title['filesize'],
      special_message: title['specialmsg'].gsub(/\r+/, '').gsub(/\n+/, ' ').strip,
      moreinfo_lb: title['moreinfolb'],
      moreinfo_txt: title['moreinfotxt'],
      legal_top: RspecEncode.process_long_desc(title['legaltop']),
      has_trailer: title['trailer'] == 'Yes',
      trailer_link: title['trailerlink'],
      details: details,
      learning_difference: (title['teaches'] == 'Just for Fun') ? '' : RspecEncode.process_long_desc(title['learningdifference']),
      legal_bottom: RspecEncode.process_long_desc(title['legalbottom']),
      review: true,
      more_like_this: true,
      write_a_review: true,
      add_to_wishlist: true,
      add_to_cart_btn: 'Add to Cart',
      buy_now_btn: 'Buy Now ▼',
      highlights: title['highlights'],

      # If content_type = 'Music' => Credit link is exist => 'True', else => 'False'
      has_credits_link: Title.map_content_type(title['contenttype']) == 'Music',

      # Get teaches
      teaches: (title['skills'] == 'Just for Fun') ? [] : Title.teach_info(title['teaches']) }
  end

  def get_actual_product_info_search_page(product_info)
    { long_name: RspecEncode.encode_title(product_info[:longname]),
      price: product_info[:price].strip,
      content_type: product_info[:content_type],
      format: product_info[:format],
      href: product_info[:href],
      age: product_info[:age] }
  end

  def get_actual_product_info_pdp_page(pdp_info)
    { long_name: RspecEncode.encode_title(pdp_info[:long_name]),
      write_a_review: pdp_info[:write_a_review],
      description: RspecEncode.process_long_desc(pdp_info[:description]),
      age: pdp_info[:age],
      curriculum: pdp_info[:curriculum],
      content_type: pdp_info[:content_type],
      notable: pdp_info[:notable],
      work_with: pdp_info[:work_with].split(','),
      publisher: pdp_info[:publisher],
      filesize: pdp_info[:size],
      special_message: pdp_info[:special_message],
      moreinfo_lb: pdp_info[:moreinfo_lb],
      moreinfo_txt: pdp_info[:moreinfo_txt],
      legal_top: RspecEncode.process_long_desc(pdp_info[:legal_top]),
      price: pdp_info[:price],
      add_to_wishlist: pdp_info[:add_to_wishlist],
      add_to_cart_btn: pdp_info[:add_to_cart_btn],
      buy_now_btn: pdp_info[:buy_now_btn],
      details: pdp_info[:details].drop(1),
      teaches: pdp_info[:teaches],
      learning_difference: RspecEncode.process_long_desc(pdp_info[:learning_difference]),
      legal_bottom: RspecEncode.process_long_desc(pdp_info[:legal_bottom]),
      review: pdp_info[:review],
      more_like_this: pdp_info[:more_like_this],
      highlights: pdp_info[:notable],

      # Get Credit link and Credit text
      has_credits_link: pdp_info[:has_credits_link],

      # Get and check trailer link
      has_trailer: pdp_info[:has_trailer],
      trailer_link: pdp_info[:trailer_link] }
  end

  def get_expected_product_info_quick_view(title)
    teaches_header = ''
    teaches = []
    unless title['teaches'] == 'Just for Fun' || title['teaches'] == ''
      teaches_header = 'Teaches:'
      teaches = title['teaches'].split(',').compact.map(&:strip).sort # split teaches into array and sort
    end

    { sku: title['sku'],
      prod_number: title['prodnumber'],
      short_name: title['shortname'],
      long_name: RspecEncode.encode_title(title['longname']),
      age: Title.calculate_age_web(title['agefrommonths'], title['agetomonths']),
      description_header: 'Description:',
      description: RspecEncode.process_long_desc(title['lfdesc']),
      teaches_header: teaches_header,
      teaches: teaches,
      workswith_header: 'Works With:',
      workswith: Title.replace_epic_platform(title['platformcompatibility'].gsub(/,\s+/, ',').split(',')),
      see_detail_link: 'See Details >',
      price: Title.calculate_price(title['pricetier'], AppCenterContent::CONST_PRICE_TIER),
      add_to_cart: 'Add to Cart',
      add_to_wishlist: 'Add to Wishlist',
      small_icon_size: %w(80 143),
      large_icon_size: %w(135 240),
      one_sentence: RspecEncode.process_long_desc(title['onesentence'])
    }
  end

  def get_actual_product_info_quick_view(quick_view_info)
    { long_name: RspecEncode.encode_title(quick_view_info[:long_name]),
      age: quick_view_info[:ages],
      description_header: quick_view_info[:description_header],
      description: RspecEncode.process_long_desc(quick_view_info[:description]),
      teaches_header: quick_view_info[:teaches_header],
      teaches: quick_view_info[:teaches].split(',').compact.map(&:strip).sort,
      workswith_header: quick_view_info[:workswith_header],
      workswith: quick_view_info[:workswith].gsub(/,\s+/, ',').split(','),
      see_detail_link: quick_view_info[:see_detail_link],
      price: quick_view_info[:price],
      add_to_cart: quick_view_info[:add_to_cart],
      add_to_wishlist: quick_view_info[:add_to_wishlist],
      small_icon_size: quick_view_info[:small_icon_size],
      large_icon_size: quick_view_info[:large_icon_size] }
  end

  def get_credits_text
    credits_lnk.click
    wait_for_credits_app_title_txt
    credits_app_title = has_credits_app_title_txt? ? credits_app_title_txt.text : 'Not display'
    find('[data-popup-name="Credits"]>div>a').click

    RspecEncode.encode_title credits_app_title
  end
end
