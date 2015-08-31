class Sqaauto1385F6Q2S14AtgSoftGoodsAddAbilityToRunAgainstDeviceSpecificStores < ActiveRecord::Migration
  def up
    @connection = ActiveRecord::Base.connection
    say 'SQAAUTO-1385 [F6Q2_S14] ATG Soft Goods - Add ability to run against device-specific stores'

    say 'Insert data for \'suites\' table'
    @connection.execute "INSERT INTO `suites` VALUES (65,'Device Stores - Soft Good Smoke Test','Device Stores - Soft Good Smoke Test',2,NULL,NULL,15);"

    say 'Insert data for \'cases\' table'
    @connection.execute "INSERT INTO `cases` VALUES (438,'DV - Purchase Flow - Credit Card - Registered User - Add Card at checkout','DV - Purchase Flow - Credit Card - Registered User - Add Card at checkout','13_dv_soft_good_smoke_test/dvst01_purchase_flow_credit_card_registered_user_add_card_at_checkout.rb',NULL,NULL);"

    say 'Insert data for \'case_suite_maps\' table'
    @connection.execute 'INSERT INTO `case_suite_maps` VALUES (407,65,384,NULL,NULL,407),(408,65,438,NULL,NULL,408);'
  end

  def down
    @connection = ActiveRecord::Base.connection
    say 'SQAAUTO-1385 [F6Q2_S14] ATG Soft Goods - Add ability to run against device-specific stores'

    say 'Delete data from \'cases\' table'
    @connection.execute 'DELETE FROM cases WHERE id = 438;'

    say 'Delete data from \'case_suite_maps\' table'
    @connection.execute 'DELETE FROM case_suite_maps WHERE id = 407 or id = 408;'

    say 'Delete data from \'suites\' table'
    @connection.execute 'DELETE FROM suites WHERE id = 65'
  end
end
