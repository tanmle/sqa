require 'nokogiri'

class WebContentUtilities
  include Capybara::DSL
  # This navigate to given url
  def go_to(url)
    visit url
    el = first('#modal_overlay', wait: 0)

    within(el) do
      find('a.close-reveal-modal.button', wait: 0).click
    end unless el.nil?
  end

  # This navigate to App Cennter you pass
  def go_appcenter(base_url)
    visit base_url
    el = first('#modal_overlay')

    within(el) do
      find('a.close-reveal-modal.button', wait: 0).click
    end unless el.nil?
  end

  # This clicks on category
  # parameter: xpath || id || unique text of category link
  def go_category(category)
    within(page.find('#sidemenu')) do
      click_link category
    end
    sleep 4
    wait_for_ajax
  end

  # This clicks on storefront link
  # parameter: xpath || id || unique text of storefront link
  def go_storefront(storefront)
    within(page.find('#tabDevices')) do
      click_link storefront
    end
    wait_for_ajax
  end

  # This clicks on Show More link
  def click_showmore
    within(page.find('#shopbycharactermore')) do
      find('li b span').click
    end
    wait_for_ajax
  end

  # DAN.DO: this class to enter a SKU value to search text box and perform searching
  def enter_sku(sku)
    wait_for_ajax
    fill_in 'suggestKeywords', with: sku + "\n"
    wait_for_ajax
  end

  # This click goes to PDP of found title after searching
  def go_pdp(sku)
    page.find(:xpath, "//div[@class='productDetail']/a[contains(@href,'#{sku.strip}')]", wait: 0).click
  end

  # This is to login from login popup
  def login(username, password)
    fill_in 'email', with: username
    fill_in 'password', with: password + "\n"
  end

  # This function is to redeem code by "Redeem Code" button on left-nav
  def redeem(username, password, code)
    click_link 'modalsigninLink'
    if page.has_css?('div#modalsignin', wait: 5)
      fill_in 'email', with: username
      fill_in 'password', with: password
      click_button 'Continue'
      fill_in 'code01-04', with: code[0, 4]
      fill_in 'code05-08', with: code[4, 4]
      fill_in 'code09-12', with: code[8, 4]
      fill_in 'code13-16', with: code[12, 4]
      if page.has_xpath?("//select[@id='state']", wait: 0)
        option = find(:xpath, "//*[@id='state']/option[2]").text
        select(option, from:  'state')
      end
      click_button 'Redeem'
    else # redo the clicking on the link for sure.
      click_link 'modalsigninLink'
      fill_in 'email', with: username
      fill_in 'password', with: password
      click_button 'Continue'
      fill_in 'code01-04', with: code[0, 4]
      fill_in 'code05-08', with: code[4, 4]
      fill_in 'code09-12', with: code[8, 4]
      fill_in 'code13-16', with: code[12, 4]
      if page.has_xpath?("//select[@id='state']", wait: 0)
        option = find(:xpath, "//*[@id='state']/option[2]").text
        select(option, from: 'state')
      end
      click_button 'Redeem'
    end
  end

  # TBD
  def wait_for_ajax
    Timeout.timeout TimeOut::CONST_READTIMEOUT do
      # handle exception: execution expired. The network is sometimes slow, default_wait_time is not enough
      begin
        active = evaluate_script 'jQuery.active'
        active = evaluate_script 'jQuery.active' until active == 0
      rescue
        puts 'The network is slow. Should optimize the network or increase the time wait'
      end
    end
  end

  def get_page_content(path)
    if page.has_css?(path)
      page.execute_script("return $(\"#{path}\").parent().html();")
    else
      return 'Cannot find #{path} in the web page. Please recheck this page'
    end
  end

  def to_html_document(str)
    Nokogiri::HTML(str)
  end
end
