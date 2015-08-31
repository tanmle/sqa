require 'capybara'
require 'site_prism'

class AtgDvCommonPage < SitePrism::Page
  element :menu_btn, :xpath, ".//div[contains(text(),'Menu')]/.."
  element :my_account_lnk, :xpath, ".//a[text()='My Account']"

  def dv_go_to_my_account
    menu_btn.click
    my_account_lnk.click
    sleep TimeOut::WAIT_MID_CONST
  end
end
