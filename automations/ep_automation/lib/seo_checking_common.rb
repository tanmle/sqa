require 'mysql'
require 'selenium-webdriver'
require 'capybara/rspec'
require 'rspec/expectations'
require 'rspec'
require 'localesweep' # this is where helper methods are stored for locale sweep
require 'lfcontentutilities.rb'
require 'const'
require 'encode'
require 'dataconvert'
require 'eplfcommon'
require 'htmlentities'

class << self
  # We check SEO for all store on US locale
  def ep_verify_seo_url_title_des(locale, storefronts)
    web_util = WebContentUtilities.new
    coder = HTMLEntities.new
    html_code = '</?[^>]+?>'
    html_regex = /[#{html_code.gsub(/./) { |char| "\\#{char}" }}]/
    title_special_char = "/+?<>',?[]}{=)(*&^%$#`~{}|"
    title_regex = /[#{title_special_char.gsub(/./) { |char| "\\#{char}" }}]/
    rows = LFExcel.new.retrieve_seo_info
    feature "SEO checking on US locale, all storefronts  - Env: #{TestInfor::CONST_ENV}", js: true do
      storefronts.each do |storefront|
        storefront_url = ''
        case storefront
        when StorefrontConst::CONST_STOREFRONT_LP then
          storefront_url = 'leappad-explorer'
        when StorefrontConst::CONST_STOREFRONT_LR then
          storefront_url = 'leapreader'
        when StorefrontConst::CONST_STOREFRONT_LE then
          storefront_url = 'leapster-explorer'
        end
        url = TestInfor.get_storefront_url locale, storefront
        context "#{storefront} storefront", js: true do
          id = 0
          rows.each do |row|
            sku = row['skuCode']
            seo_url = row['seoURL']
            seo_title = row['seoTitle_en']
            seo_des = row['seoDescription_en']
            sku_inpage = false
            url_pdp = title_pdp = desc_pdp = ''

            context "#{id += 1}. SKU: #{sku}", js: true do
              before :all do
                sku_inpage = false
                web_util.go_to url
                web_util.enter_sku sku.strip
              end

              scenario "Checking SKU = #{sku} exists in Store", js: true do
                if page.has_xpath?("//div[@class='productDetail']/a[contains(@href,'#{sku.strip}')]", wait: 0)
                  sku_inpage = true
                  expect(sku_inpage).to eq true
                  web_util.go_pdp(sku)
                  url_pdp = page.current_url
                  title_pdp = page.title
                  desc_pdp = find(:xpath, '//head/meta[@name="description"]', visible: false).native.attribute('content')
                else
                  fail(Exception.new, "Expected: The title with sku = #{sku} is missing on this store")
                end
              end

              # Check URL
              scenario "Checking correct current storefront in URL: \"#{storefront_url}\"", js: true do
                if sku_inpage
                  expect(url_pdp).to include(storefront_url)
                else
                  pending("This title with sku = #{sku} is missing on this store")
                end
              end

              scenario "Checking URL contains SEO url: \"#{seo_url}\"", js: true do
                if sku_inpage
                  expect(url_pdp).to include(seo_url)
                else
                  pending("This title with sku = #{sku} is missing on this store")
                end
              end

              # Check title
              scenario "Checking title equals \"#{seo_title}\"", js: true do
                if sku_inpage
                  expect(coder.decode(title_pdp)).to eq(coder.decode(seo_title))
                else
                  pending("This title with sku = #{sku} is missing on this store")
                end
              end

              scenario "Checking title does not contains special characters or html code: #{title_special_char}", js: true do
                if sku_inpage
                  title_pdp.should_not match(title_regex)
                else
                  pending("This title with sku = #{sku} is missing on this store")
                end
              end

              # Check description
              scenario "Checking description equals \"#{seo_des}\"", js: true do
                if sku_inpage
                  expect(coder.decode(desc_pdp)).to eq(coder.decode(seo_des))
                else
                  pending("This title with sku = #{sku} is missing on this store")
                end
              end

              scenario "Checking description does not contains special characters or html code: #{html_code}", js: true do
                if sku_inpage
                  desc_pdp.should_not match(html_regex)
                else
                  pending("This title with sku = #{sku} is missing on this store")
                end
              end
            end # end context
          end # end row
        end # storefront context
      end # end storefronts
    end # end feature
  end
end
