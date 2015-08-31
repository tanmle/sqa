require File.expand_path('../../spec_helper', __FILE__)
require 'atg_home_page'
require 'mail_home_page'
require 'mail_detail_page'
require 'csc_login_page'
require 'csc_home_page'
require 'csc_home_customer_infor_page'
require 'csc_home_checkout_page'

=begin
Verify user can create a order on CSC page with a new account
=end

# initial variables
atg_home_page = HomeATG.new
csc_login_page = LoginCSC.new
csc_home_customer_info = nil
csc_home_checkout_page = nil
csc_home_page = nil
mail_home_page = HomePageMail.new
mail_detail_page = nil
cookie_session_id = nil

# Order info
prod_info = nil
check_out_info = nil
order_view_info = nil
email_order_info = nil
order_total = nil
total_price = nil
added_to_cart_info = nil
email = Data::EMAIL_NEW_CSC_CONST
qty = 1

feature "TC34 - Order on CSC - Ensure that an new user able to place order on CSC - ENV = '#{Data::ENV_CONST}' - Locale = '#{Data::LOCALE_CONST}'", js: true do
  # before section: pre-conditions
  before :all, js: true do
    cookie_session_id = atg_home_page.load
    prod_info = atg_home_page.get_random_product_info
    csc_home_page = csc_login_page.login(Data::CSC_USERNAME_CONST, Data::CSC_PASSWORD_CONST)
    csc_home_customer_info = csc_home_page.goto_customer_info
    csc_home_customer_info.create_new_customer(
      Data::FIRSTNAME_CONST,
      Data::LASTNAME_CONST,
      Data::COUNTRY_CONST,
      email,
      Data::FIRSTNAME_CONST
    )
  end

  context 'Print Session ID' do
    scenario '' do
      pending "***SESSION_ID: #{cookie_session_id}"
    end
  end

  # steps, verify points section
  context 'Order on CSC page', js: true do
    scenario '1. Add new address', js: true do
      csc_home_customer_info.add_new_address(
        Data::FIRSTNAME_CONST,
        Data::LASTNAME_CONST,
        Data::COUNTRY_DETAIL_CONST,
        Data::ADDRESS1_CONST,
        Data::CITY_CONST,
        Data::STATE_CODE_CONST,
        Data::ZIP_CONST,
        Data::PHONE_CONST
      )
    end

    scenario '2. Select site', js: true do
      csc_home_checkout_page = csc_home_page.select_site(Data::CSC_SITE_CONST)
    end

    scenario '3. Add to cart 1 item', js: true do
      added_to_cart_info = csc_home_checkout_page.add_to_cart(prod_info[:id], 1)
      if added_to_cart_info.include?('Cannot add sku')
        pending added_to_cart_info
        fail
      end
    end

    scenario '4. Check out', js: true do
      check_out_info = csc_home_checkout_page.check_out(
        email,
        "#{Data::FIRSTNAME_CONST} #{Data::LASTNAME_CONST}",
        Data::CARD_NUMBER_CONST,
        Data::EXP_MONTH_NUMBER_CONST,
        Data::EXP_YEAR_CONST,
        Data::SECURITY_CODE_CONST,
        Data::COUNTRY_DETAIL_CONST
      )
    end
  end

  context 'Verify information on CSC tool', js: true do
    before :all, js: true do
      order_view_info = csc_home_page.get_order_overview_info
    end

    scenario '1. Verify Order number', js: true do
      expect(order_view_info[:id]).to eq(check_out_info[:id])
    end

    scenario '2. Verify customer full name', js: true do
      expect(order_view_info[:customer]).to eq("#{Data::LASTNAME_CONST}, #{Data::FIRSTNAME_CONST}")
    end

    scenario '3. Verify email address', js: true do
      expect(order_view_info[:email]).to eq(email)
    end

    scenario '4. Verify order status', js: true do
      expect(order_view_info[:status]).to eq(ProductInformation::ORDER_FULLFILL_STATUS_CONST)
    end

    scenario '5. Verify item description', js: true do
      if (order_view_info[:description]).include?(prod_info[:title])
        expect(order_view_info[:description]).to include(prod_info[:title])
      else
        expect(added_to_cart_info[:title]).to include(order_view_info[:description])
      end
    end

    scenario '6. Verify Qty', js: true do
      expect(order_view_info[:quatity]).to eq('1')
    end

    scenario '7. Verify price', js: true do
      expect(order_view_info[:price_each]).to eq(prod_info[:price].gsub('$', ProductInformation::CURRENCY_CONST))
    end

    scenario '8. Verify total price', js: true do
      total_price = '%.2f' % prod_info[:price][prod_info[:price].rindex('$') + 1..-1].to_f * qty.round(2)
      expect(order_view_info[:total_price]).to eq("#{ProductInformation::CURRENCY_CONST}#{total_price}")
    end

    scenario '9. Verify subtotal', js: true do
      expect(order_view_info[:subtotal]).to eq("#{ProductInformation::CURRENCY_CONST}#{total_price}")
    end

    scenario '10. Verify shipping cost', js: true do
      expect(order_view_info[:shipping_cost]).to eq(check_out_info[:shipping_price].gsub('$', ProductInformation::CURRENCY_CONST))
    end

    scenario '11. Verify order total', js: true do
      order_total = '%.2f' % csc_home_page.caculate_order_total
      expect(order_view_info[:order_total]).to eq("#{ProductInformation::CURRENCY_CONST}#{order_total}")
    end

    scenario '12. Verify shipping address', js: true do
      expect(order_view_info[:shipping_address]).to eq(ProductInformation::ADDRESS_CSC_CONST)
    end

    scenario '13. Verify shipping method', js: true do
      expect(order_view_info[:shipping_method]).to eq((ProductInformation::SHIPPING_METHOD_CONST % '').strip)
    end

    scenario '14. Verify billing type', js: true do
      expect(order_view_info[:billing_type].delete(' ')).to eq(ProductInformation::PAYMENT_METHOD_CSC_CONST)
    end

    scenario '15. Verify billing address', js: true do
      expect(order_view_info[:billing_address]).to eq(ProductInformation::ADDRESS_CSC_CONST)
    end

    scenario '16. Verify billing amount', js: true do
      expect(order_view_info[:billing_amount]).to eq("#{ProductInformation::CURRENCY_CONST}#{order_total}")
    end

    scenario '17. Verify ogrinator' do
      originator = csc_home_page.get_originator_of_order(check_out_info[:id])
      expect(originator).to eq('Contact Center')
    end

    after :all do
      csc_home_page.logout_administrator
    end
  end

  context 'Verify information on Email page', js: true do
    before :all, js: true do
      email_part1 = email[0..email.index('@') - 1]
      mail_detail_page = mail_home_page.go_to_mail_detail email_part1
      email_order_info = mail_detail_page.get_order_information_from_csc
    end

    context 'Verify product detail is correct on email' do
      scenario '1. Verify order number', js: true do
        expect(email_order_info[:id]).to include(check_out_info[:id])
      end

      scenario '2. Title' do
        expect(email_order_info[:prod_detail]).to include(added_to_cart_info[:title])
      end

      scenario '3. SKU' do
        expect(email_order_info[:prod_detail]).to include(added_to_cart_info[:sku])
      end

      scenario '4. Total' do
        expect(email_order_info[:prod_detail]).to include(prod_info[:price][prod_info[:price].rindex('$')..-1])
      end
    end

    context 'Verify shipping details' do
      scenario '1. Title' do
        expect(email_order_info[:shipping_detail]).to include(added_to_cart_info[:title])
      end

      scenario '2. Shipping method' do
        expect(email_order_info[:shipping_detail]).to include((ProductInformation::SHIPPING_METHOD_CONST % '').strip)
      end

      scenario '3. Shipping address' do
        expect(email_order_info[:shipping_detail]).to include(Data::ADDRESS_MAIL_FROM_CSC_CONST)
      end
    end

    context 'Verify billing details' do
      scenario '1. Type', js: true do
        expect(email_order_info[:billing_detail]).to include(ProductInformation::BILLING_TYPE_CONST)
      end

      scenario '2. Address', js: true do
        expect(email_order_info[:billing_detail]).to include(Data::ADDRESS_MAIL_FROM_CSC_CONST)
      end

      scenario '3. Amount', js: true do
        expect(email_order_info[:billing_detail]).to include(order_total.to_s)
      end
    end
  end
end
