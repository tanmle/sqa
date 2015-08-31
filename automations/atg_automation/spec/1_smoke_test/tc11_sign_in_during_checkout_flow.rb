require File.expand_path('../../spec_helper', __FILE__)
require 'atg_home_page'
require 'atg_login_register_page'
require 'atg_my_profile_page'
require 'atg_checkout_page'
require 'atg_checkout_shipping_page'
require 'atg_checkout_payment_page'
require 'atg_checkout_review_page'
require 'atg_checkout_confirmation_page'
require 'mail_home_page'
require 'mail_detail_page'
require 'csc_login_page'
require 'csc_home_page'

=begin
Verify that user can check out with an existing account
=end

# initial variables
atg_home_page = HomeATG.new
atg_login_page = nil
atg_my_profile_page = nil
atg_checkout_page = nil
atg_shipping_page = nil
atg_payment_page = nil
atg_review_page = nil
atg_confirmation_page = nil
mail_home_page = HomePageMail.new
mail_detail_page = nil
csc_login_page = LoginCSC.new
csc_home_page = nil
cookie_session_id = nil

# Order info
order_id = nil
prod_info = nil
overview_info = nil
shipping_method = nil
total_price = nil
order_total_price = nil
payment_method = nil

# constants
qty = 1
sale_tax = nil

feature "TC11 - Checkout - Sign in during Checkout flow - ENV = '#{Data::ENV_CONST}' - Locale = '#{Data::LOCALE_CONST}'", js: true do
  # before section: pre-conditions
  before :all do
    # Go to App Center page
    cookie_session_id = atg_home_page.load

    # Get random product info
    prod_info = atg_home_page.get_random_product_info

    # Go to Login page -> Login to account
    atg_login_page = atg_home_page.goto_login
    atg_my_profile_page = atg_login_page.login(Data::EMAIL_EXIST_FULL_CONST, Data::PASSWORD_CONST)

    # Remove all items in Shop Cart
    atg_my_profile_page.remove_all_items_in_shop_cart
    atg_my_profile_page.logout
  end

  context 'Print Session ID' do
    scenario '' do
      pending "***SESSION_ID: #{cookie_session_id}"
    end
  end

  # steps, verify points section
  context 'Verify that user can check out with an existing account' do
    scenario '1. Add to cart' do
      atg_my_profile_page.add_to_cart prod_info[:id]
    end

    scenario '2. Go to Check out page' do
      atg_checkout_page = atg_my_profile_page.goto_checkout
    end

    scenario '3. Use an existing account to login' do
      atg_checkout_page.checkout_as_existing_user Data::EMAIL_EXIST_FULL_CONST, Data::PASSWORD_CONST
    end

    scenario '4. Go to Shipping page' do
      atg_shipping_page = atg_checkout_page.check_out_as_logged_in_account
      atg_shipping_page.choose_shipping_method ProductInformation::SHIPPING_METHOD_CONST

      # get chosen shipping method info
      shipping_method = atg_shipping_page.get_shipping_method_checked
    end

    scenario '5. Go to Payment page' do
      atg_payment_page = atg_shipping_page.shipping_as_full_information_account
    end

    scenario '6. Go to Review page' do
      atg_review_page = atg_payment_page.pay_as_full_information_account
    end

    scenario '7. Go to Confirmation page' do
      atg_confirmation_page = atg_review_page.place_order
      order_id = atg_confirmation_page.get_order_id
      overview_info = atg_confirmation_page.get_order_overview_info
      atg_confirmation_page.record_order_id Data::EMAIL_EXIST_FULL_CONST
    end

    context '8. Verify information on Confirmation page' do
      scenario 'Verify complete order message' do
        expect(overview_info[:complete]).to match(ProductInformation::ORDER_COMPLETE_MESSAGE_CONST)
      end

      scenario 'Verify Shipped items information' do
        if prod_info[:price] != ''
          total_price = atg_confirmation_page.cal_total_price(prod_info[:price])
        else
          total_price = atg_confirmation_page.cal_total_price(prod_info[:sale])
        end
        order_total_price = '%.2f' % atg_confirmation_page.calculate_order_total
        sale_tax = '%.2f' % atg_confirmation_page.get_sale_tax.gsub(/[CAD,$]/, '').to_f

        if prod_info[:price] != ''
          expect(overview_info[:details]).to include("Order Details Shipped Items Qty Price Total #{prod_info[:title]} 1 #{prod_info[:price]} $#{total_price} Order Subtotal: $#{total_price} Shipping: #{shipping_method[:price]} Sales Tax: $#{sale_tax} Order Total: $#{order_total_price}")
        else
          expect(overview_info[:details]).to include("Order Details Shipped Items Qty Price Total #{prod_info[:title]} 1 #{prod_info[:price_sale]} $#{total_price} Order Subtotal: $#{total_price} Shipping: #{shipping_method[:price]} Sales Tax: $#{sale_tax} Order Total: $#{order_total_price}")
        end
      end

      scenario 'Payment method information' do
        payment_method = "#{Data::CARD_TEXT_CONST} $#{order_total_price}"
        expect(overview_info[:details]).to include("Payment Method #{payment_method}")
      end

      scenario 'Verify order summary info' do
        expect(overview_info[:summary]).to eq(ProductInformation::ORDER_SUMMARY_TEXT_CONST % [Data::EMAIL_EXIST_FULL_CONST, shipping_method[:text_on_confirmation]])
      end
    end

    context '9. Verify information on Email page' do
      before :all do
        mail_detail_page = mail_home_page.go_to_mail_detail Data::EMAIL_EXIST_FULL_CONST
      end

      scenario 'Verify order number' do
        expect(mail_detail_page.order_number_txt.text).to eq("ORDER NUMBER: #{order_id}")
      end

      scenario 'Verify shipping detail info' do
        if prod_info[:price] != ''
          details_email_text1 = ProductInformation::SHIPPING_DETAIL_TEXT_EMAIL_PAGE_CONST % " #{prod_info[:title]} 1 #{prod_info[:price]} $#{total_price} Order subtotal: $#{total_price}"
        else
          details_email_text1 = ProductInformation::SHIPPING_DETAIL_TEXT_EMAIL_PAGE_CONST % " #{prod_info[:title]} 1 #{prod_info[:price_sale]} $#{total_price} Order subtotal: $#{total_price}"
        end
        details_email_text2 = "Shipping: #{shipping_method[:price]} Tax: $#{sale_tax} Purchase Total: $#{order_total_price}"

        expect(mail_detail_page.shipping_detail_txt.text).to include(details_email_text1.gsub(' - Green', '').gsub(' - Pink', ''))
        expect(mail_detail_page.shipping_detail_txt.text).to include(details_email_text2)
      end

      scenario 'Verify payment method info' do
        expect(mail_detail_page.payment_method_txt.text.gsub!(/\s/, '')).to eq(payment_method.gsub!(/\s/, ''))
      end

      scenario 'Verify shipping method info' do
        expect(mail_detail_page.shipping_method_txt.text).to eq(shipping_method[:text_on_email])
      end

      scenario 'Verify bill to info' do
        expect(mail_detail_page.bill_to_txt.text).to eq(ProductInformation::ADDRESS_CONST)
      end
    end

    context '10. Verify information on CSC tool' do
      before :all do
        csc_home_page = csc_login_page.login(Data::CSC_USERNAME_CONST, Data::CSC_PASSWORD_CONST)
        csc_home_page.show_sidebar
        csc_home_page.find_order_by_id order_id
      end

      scenario 'Verify Order number' do
        expect(csc_home_page.order_view.order_number_txt.text).to eq(order_id)
      end

      scenario 'Verify customer full name' do
        expect(csc_home_page.order_view.customer_txt.text).to eq("#{Data::LASTNAME_CONST}, #{Data::FIRSTNAME_CONST}")
      end

      scenario 'Verify email address' do
        expect(csc_home_page.order_view.email_address_txt.text).to eq(Data::EMAIL_EXIST_FULL_CONST)
      end

      scenario 'Verify order status' do
        expect(csc_home_page.order_view.status_txt.text).to eq(ProductInformation::ORDER_FULLFILL_STATUS_CONST)
      end

      scenario 'Verify item description' do
        expect(csc_home_page.order_view.item_description_txt).text.to eq(prod_info[:title])
      end

      scenario 'Verify Qty' do
        expect(csc_home_page.order_view.qty_txt.text).to eq(qty.to_s)
      end

      scenario 'Verify price' do
        if prod_info[:price] != ''
          expect(csc_home_page.order_view.price_each_txt.text).to eq(prod_info[:price].gsub('$', ProductInformation::CURRENCY_CONST))
        else
          expect(csc_home_page.order_view.price_each_txt.text).to eq(prod_info[:price_sale].gsub('$', ProductInformation::CURRENCY_CONST))
        end
      end

      scenario 'Verify total price' do
        expect(csc_home_page.order_view.total_price_txt.text).to eq("#{ProductInformation::CURRENCY_CONST}#{total_price}")
      end

      scenario 'Verify subtotal' do
        expect(csc_home_page.order_view.subtotal_txt.text).to eq("#{ProductInformation::CURRENCY_CONST}#{total_price}")
      end

      scenario 'Verify shipping cost' do
        expect(csc_home_page.order_view.shipping_txt.text).to eq(shipping_method[:price].gsub('$', ProductInformation::CURRENCY_CONST))
      end

      scenario 'Verify tax cost' do
        expect(csc_home_page.order_view.tax_txt.text).to eq("#{ProductInformation::CURRENCY_CONST}#{sale_tax}")
      end

      scenario 'Verify order total' do
        expect(csc_home_page.order_view.order_total_txt.text).to eq("#{ProductInformation::CURRENCY_CONST}#{order_total_price}")
      end

      scenario 'Verify shipping address' do
        expect(csc_home_page.order_view.shipping_address_txt.text).to eq(ProductInformation::ADDRESS_CSC_CONST)
      end

      scenario 'Verify shipping method' do
        expect(csc_home_page.order_view.shipping_method_txt.text).to eq(ProductInformation::SHIPPING_METHOD_CONST)
      end

      scenario 'Verify billing type' do
        expect(csc_home_page.order_view.type_txt.text.delete(' ')).to eq(ProductInformation::PAYMENT_METHOD_CSC_CONST)
      end

      scenario 'Verify billing address' do
        expect(csc_home_page.order_view.billing_address_txt.text).to eq(ProductInformation::ADDRESS_CSC_CONST)
      end

      scenario 'Verify billing amount' do
        expect(csc_home_page.order_view.amount_txt.text).to eq("#{ProductInformation::CURRENCY_CONST}#{order_total_price}")
      end
    end
  end
end
