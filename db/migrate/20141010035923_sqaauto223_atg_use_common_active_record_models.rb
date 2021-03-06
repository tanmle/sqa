class Sqaauto223AtgUseCommonActiveRecordModels < ActiveRecord::Migration
  def up
    say 'seed initial - Sqaauto223AtgUseCommonActiveRecordModels'
    
    say 'initial atg content data for \'suites\' table'
    Suite.create(id: 43, name: 'Hard Good Smoke Test', description: '', silo_id: 2, order: 43)
    Suite.create(id: 44, name: 'Health Checking UAT, CSC, VIN', description: '', silo_id: 2, order: 44)
    Suite.create(id: 45, name: 'ATG Content', description: '', silo_id: 2, order: 45)
    Suite.create(id: 46, name: 'Cabo ATG Content', description: '', silo_id: 2, order: 46)
    Suite.create(id: 47, name: 'French Cabo ATG Content', description: '', silo_id: 2, order: 47)
    
    say 'initial atg content data for \'cases\' table'
    Case.create(id: 219, name: '(Precondition) Create new full account', description: '', script_path: '1_smoke_test/pre_condition.rb')
    Case.create(id: 220, name: 'New Registration', description: '', script_path: '1_smoke_test/tc01_new_registration.rb')
    Case.create(id: 221, name: 'Register at checkout', description: '', script_path: '1_smoke_test/tc02_register_at_checkout.rb')
    Case.create(id: 222, name: 'Add an address to account', description: '', script_path: '1_smoke_test/tc03_add_an_address.rb')
    Case.create(id: 223, name: 'Add an bad address', description: '', script_path: '1_smoke_test/tc04_add_address_needs_to_be_checked.rb')
    Case.create(id: 224, name: 'Add card and billing address', description: '', script_path: '1_smoke_test/tc05_add_card_and_billing_address.rb')
    Case.create(id: 225, name: 'Log in', description: '', script_path: '1_smoke_test/tc06_log_into_site.rb')
    Case.create(id: 226, name: 'Log out', description: '', script_path: '1_smoke_test/tc07_log_out_site.rb')
    Case.create(id: 227, name: 'Check out with existing user', description: '', script_path: '1_smoke_test/tc09_existing_user_checkout.rb')
    Case.create(id: 228, name: 'Check out with new user', description: '', script_path: '1_smoke_test/tc10_new_user_checkout.rb')
    Case.create(id: 229, name: 'Sign in during checkout from wishlist dropdown', description: '', script_path: '1_smoke_test/tc11_1_sign_in_during_checkout_wishlist_dropdown.rb')
    Case.create(id: 230, name: 'Sign in during checkout from wishlist page', description: '', script_path: '1_smoke_test/tc11_2_sign_in_during_checkout_wishlist_page.rb')
    Case.create(id: 231, name: 'Sign in during checkout flow', description: '', script_path: '1_smoke_test/tc11_sign_in_during_checkout_flow.rb')
    Case.create(id: 232, name: 'Check out as guest', description: '', script_path: '1_smoke_test/tc12_guest_user_checkout.rb')
    Case.create(id: 233, name: 'Check address during checkout flow', description: '', script_path: '1_smoke_test/tc15_address_check_during_checkout_flow.rb')
    Case.create(id: 234, name: 'Look up user by email', description: '', script_path: '1_smoke_test/tc16_look_up_user_by_email.rb')
    Case.create(id: 235, name: 'Bring up pdp page', description: '', script_path: '1_smoke_test/tc22_bring_up_pdp_page.rb')
    Case.create(id: 236, name: 'Add to cart from pdp page', description: '', script_path: '1_smoke_test/tc23_add_to_cart_from_pdp_page.rb')
    Case.create(id: 237, name: 'Add to wishlist from pdp page', description: '', script_path: '1_smoke_test/tc24_add_to_wishlist_from_pdp_page.rb')
    Case.create(id: 238, name: 'Bring up quick view overlay', description: '', script_path: '1_smoke_test/tc25_bring_up_quick_view_overlay.rb')
    Case.create(id: 239, name: 'Add to cart from quick view overlay', description: '', script_path: '1_smoke_test/tc26_add_to_cart_from_quick_view_overlay.rb')
    Case.create(id: 240, name: 'Add to wishlist from quick view page', description: '', script_path: '1_smoke_test/tc27_add_to_wishlist_from_quick_view_page.rb')
    Case.create(id: 241, name: 'Add to cart directly form the catalog page', description: '', script_path: '1_smoke_test/tc28_add_to_cart_directly_from_the_catalog_page.rb')
    Case.create(id: 242, name: 'Sort on catalog page', description: '', script_path: '1_smoke_test/tc29_sort_on_catalog_page.rb')
    Case.create(id: 243, name: 'Filter by on catalog page', description: '', script_path: '1_smoke_test/tc30_filter_by_on_catalog_page.rb')
    Case.create(id: 244, name: 'Add to wishlist as guest', description: '', script_path: '1_smoke_test/tc31_add_to_wishlist_as_guest.rb')
    Case.create(id: 245, name: 'Serach on catalog page', description: '', script_path: '1_smoke_test/tc32_search_on_catalog_page.rb')
    Case.create(id: 246, name: 'Order on csc page with existing user', description: '', script_path: '1_smoke_test/tc33_order_on_csc_existing_user.rb')
    Case.create(id: 247, name: 'Order on csc page with new user', description: '', script_path: '1_smoke_test/tc34_order_on_csc_new_user.rb')
    Case.create(id: 248, name: 'Returns can be done without a physical return', description: '', script_path: '1_smoke_test/tc36_returns_can_be_done_without_a_physical_return.rb')
    Case.create(id: 249, name: 'Change email account', description: '', script_path: '1_smoke_test/tc37_change_email_account_from_name_A_to_name_B.rb')
    Case.create(id: 250, name: 'Health check for UAT server', description: '', script_path: '2_health_check/tc01_uat_server.rb')
    Case.create(id: 251, name: 'Health check login to UAT server', description: '', script_path: '2_health_check/tc02_login_to_uat.rb')
    Case.create(id: 252, name: 'Health check for CSC server', description: '', script_path: '2_health_check/tc03_csc_server.rb')
    Case.create(id: 253, name: 'Health check login to CSC server', description: '', script_path: '2_health_check/tc04_login_to_csc.rb')
    Case.create(id: 254, name: 'Health check for Vindicia server', description: '', script_path: '2_health_check/tc05_vindicia_server.rb')
    Case.create(id: 255, name: 'Health check login to Vindicia server', description: '', script_path: '2_health_check/tc06_login_to_vindicia.rb')
    Case.create(id: 256, name: 'Search SKU and product detail checking', description: '', script_path: '3_content/tc01_search_pdp_checking.rb')
    Case.create(id: 257, name: 'Search SKU negative checking', description: '', script_path: '3_content/tc02_search_pdp_checking_negative.rb')
    Case.create(id: 258, name: 'Skill catalog checking', description: '', script_path: '3_content/tc03_skill_catalog_checking.rb')
    Case.create(id: 259, name: 'Skill catalog negative checking', description: '', script_path: '3_content/tc04_skill_catalog_checking_negative.rb')
    Case.create(id: 260, name: 'Age catalog checking', description: '', script_path: '3_content/tc05_age_catalog_checking.rb')
    Case.create(id: 261, name: 'Age catalog negative checking', description: '', script_path: '3_content/tc06_age_catalog_checking_negative.rb')
    Case.create(id: 262, name: 'Product catalog checking', description: '', script_path: '3_content/tc07_product_catalog_checking.rb')
    Case.create(id: 263, name: 'Product catalog negative checking', description: '', script_path: '3_content/tc08_product_catalog_checking_negative.rb')
    Case.create(id: 264, name: 'Character catalog checking', description: '', script_path: '3_content/tc09_character_catalog_checking.rb')
    Case.create(id: 265, name: 'Character catalog negative checking', description: '', script_path: '3_content/tc10_character_catalog_checking_negative.rb')
    Case.create(id: 266, name: 'Price catalog checking', description: '', script_path: '3_content/tc11_price_catalog_checking.rb')
    Case.create(id: 267, name: 'Price catalog negative checking', description: '', script_path: '3_content/tc12_price_catalog_checking_negative.rb')
    Case.create(id: 268, name: 'Type catalog checking', description: '', script_path: '3_content/tc13_type_catalog_checking.rb')
    Case.create(id: 269, name: 'Type catalog negative checking', description: '', script_path: '3_content/tc14_type_catalog_checking_negative.rb')
    Case.create(id: 270, name: 'Category catalog checking', description: '', script_path: '3_content/tc15_category_catalog_checking.rb')
    Case.create(id: 271, name: 'Category catalog negative checking', description: '', script_path: '3_content/tc16_category_catalog_checking_negative.rb')
    Case.create(id: 272, name: 'Quick View Information Checking', description: '', script_path: '3_content/tc17_quick_view_checking.rb')
    Case.create(id: 273, name: 'App purchasing with credit card', description: '', script_path: '3_content/tc18_app_purchasing_credit_card_checking.rb')
    Case.create(id: 274, name: 'App purchasing using existing balance', description: '', script_path: '3_content/tc19_app_purchasing_existing_balance_checking.rb')
    Case.create(id: 275, name: 'App purchasing using paypal', description: '', script_path: '3_content/tc20_app_purchasing_paypal_checking.rb')
    Case.create(id: 276, name: 'Cabo Search SKU and Product detail checking', description: '', script_path: '4_content_cabo/tc01_cabo_search_pdp_checking.rb')
    Case.create(id: 277, name: 'Cabo Search SKU negative checking', description: '', script_path: '4_content_cabo/tc02_cabo_search_pdp_checking_negative.rb')
    Case.create(id: 278, name: 'Cabo Category catalog checking', description: '', script_path: '4_content_cabo/tc03_cabo_category_catalog_checking.rb')
    Case.create(id: 279, name: 'Cabo Category catalog negative checking', description: '', script_path: '4_content_cabo/tc04_cabo_category_catalog_checking_negative.rb')
    Case.create(id: 280, name: 'Cabo Age catalog checking', description: '', script_path: '4_content_cabo/tc05_cabo_age_catalog_checking.rb')
    Case.create(id: 281, name: 'Cabo Age catalog negative checking', description: '', script_path: '4_content_cabo/tc06_cabo_age_catalog_checking_negative.rb')
    Case.create(id: 282, name: 'Cabo Skill catalog checking', description: '', script_path: '4_content_cabo/tc07_cabo_skill_catalog_checking.rb')
    Case.create(id: 283, name: 'Cabo Skill catalog negative checking', description: '', script_path: '4_content_cabo/tc08_cabo_skill_catalog_checking_negative.rb')
    Case.create(id: 284, name: 'Cabo Character catalog checking', description: '', script_path: '4_content_cabo/tc09_cabo_character_catalog_checking.rb')
    Case.create(id: 285, name: 'Cabo Character catalog negative checking', description: '', script_path: '4_content_cabo/tc10_cabo_character_catalog_checking_negative.rb')
    Case.create(id: 286, name: 'Cabo Shop All App catalog checking', description: '', script_path: '4_content_cabo/tc11_cabo_shop_all_app_catalog_checking.rb')
    Case.create(id: 287, name: 'Cabo Shop All App catalog negative checking', description: '', script_path: '4_content_cabo/tc12_cabo_shop_all_app_catalog_checking_negative.rb')
    Case.create(id: 288, name: 'French Cabo Search SKU and Product detail checking', description: '', script_path: '5_content_cabo_french/tc01_cabo_french_search_pdp_checking.rb')
    Case.create(id: 289, name: 'French Cabo Search SKU negative checking', description: '', script_path: '5_content_cabo_french/tc02_cabo_french_search_pdp_checking_negative.rb')
    Case.create(id: 290, name: 'French Cabo Category catalog checking', description: '', script_path: '5_content_cabo_french/tc03_cabo_french_category_catalog_checking.rb')
    Case.create(id: 291, name: 'French Cabo Category cattalog negative checking', description: '', script_path: '5_content_cabo_french/tc04_cabo_french_category_catalog_checking_negative.rb')
    Case.create(id: 292, name: 'French Cabo Age catalog checking', description: '', script_path: '5_content_cabo_french/tc05_cabo_french_age_catalog_checking.rb')
    Case.create(id: 293, name: 'French Cabo Age catalog negative checking', description: '', script_path: '5_content_cabo_french/tc06_cabo_french_age_catalog_checking_negative.rb')
    Case.create(id: 294, name: 'French Cabo Skill catalog checking', description: '', script_path: '5_content_cabo_french/tc07_cabo_french_skill_catalog_checking.rb')
    Case.create(id: 295, name: 'French Cabo Skill catalog negative checking', description: '', script_path: '5_content_cabo_french/tc08_cabo_french_skill_catalog_checking_negative.rb')
    Case.create(id: 296, name: 'French Cabo Character catalog checking', description: '', script_path: '5_content_cabo_french/tc09_cabo_french_character_catalog_checking.rb')
    Case.create(id: 297, name: 'French Cabo Character catalog negative checking', description: '', script_path: '5_content_cabo_french/tc10_cabo_french_character_catalog_checking_negative.rb')
    Case.create(id: 298, name: 'French Cabo Shop All App catalog checking', description: '', script_path: '5_content_cabo_french/tc11_cabo_french_shop_all_app_catalog_checking.rb')
    Case.create(id: 299, name: 'French Cabo Shop All App catalog negative checking', description: '', script_path: '5_content_cabo_french/tc12_cabo_french_shop_all_app_catalog_checking_negative.rb')
    
    say 'initial atg data for \'case_suite_maps\' table '
    (219..249).each { |n| CaseSuiteMap.create(suite_id: 43, case_id: n, order: n)}
    (250..255).each { |n| CaseSuiteMap.create(suite_id: 44, case_id: n, order: n)}
    (256..275).each { |n| CaseSuiteMap.create(suite_id: 45, case_id: n, order: n)}
    (276..285).each { |n| CaseSuiteMap.create(suite_id: 46, case_id: n, order: n)}
    (286..299).each { |n| CaseSuiteMap.create(suite_id: 47, case_id: n, order: n)}
  end
end
