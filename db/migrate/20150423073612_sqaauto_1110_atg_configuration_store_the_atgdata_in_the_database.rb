class Sqaauto1110AtgConfigurationStoreTheAtgdataInTheDatabase < ActiveRecord::Migration
  def up
    say 'SQAAUTO-1110 [F6Q1_S10] ATG configuration - Store the ATG data in the database'

    say 'SQAAUTO-1111 ATG Configuration - Store PINs csv in the database'
    create_table 'pins', force: true do |t|
      t.string 'env', limit: 10, default: '', null: false
      t.string 'code_type', limit: 5, default: '', null: false
      t.string 'pin_number', limit: 20, default: '', null: false
      t.string 'platform', default: '', null: true
      t.string 'location', limit: 100, default: '', null: true
      t.string 'amount', limit: 5, default: '', null: true
      t.string 'currency', limit: 5, default: '', null: true
      t.string 'status', limit: 10, default: '', null: false
      t.datetime 'created_at'
      t.datetime 'updated_at'
    end

    say 'SQAAUTO-1112 ATG Configuration - Store AppCenter Account, Paypal Account, Vindicia Account data in the database'
    create_table 'atg_configurations', force: true do |t|
      t.binary 'data'
      t.datetime 'created_at'
      t.datetime 'updated_at'
    end

    say 'Insert data into \'atg_configurations\' table'
    @connection = ActiveRecord::Base.connection
    @connection.execute "INSERT INTO `atg_configurations` VALUES (1,'{\\\"ac_account\\\":{\\\"empty_acc\\\":[\\\"pm201409090848057us@leapfrog.test\\\",\\\"654321\\\"],\\\"credit_acc\\\":[\\\"ltrc_atg_uat_us_612201410531@sharklasers.com\\\",\\\"123456\\\"],\\\"balance_acc\\\":[\\\"pm201409090910038us@leapfrog.test\\\",\\\"123456\\\"],\\\"credit_balance_acc\\\":[\\\"pm201409090840046us@leapfrog.test\\\",\\\"123456\\\"]},\\\"paypal_account\\\":{\\\"p_us_acc\\\":[\\\"hantr1_1352963954_per@yahoo.com\\\",\\\"352965367\\\"],\\\"p_ca_acc\\\":[\\\"hant11_1352975031_per@yahoo.com\\\",\\\"12345678\\\"],\\\"p_uk_acc\\\":[\\\"hantr5_1352968322_per@yahoo.com\\\",\\\"12345678\\\"],\\\"p_ie_acc\\\":[\\\"hantr5_1352968322_per@yahoo.com\\\",\\\"12345678\\\"],\\\"p_au_acc\\\":[\\\"hantr6_1352969230_per@yahoo.com\\\",\\\"12345678\\\"],\\\"p_row_acc\\\":[\\\"hantr7_1352969911_per@yahoo.com\\\",\\\"12345678\\\"]},\\\"catalog_entry\\\":{\\\"prod_id\\\":\\\"prod58997-96914\\\",\\\"ce_sku\\\":\\\"58997-96914\\\",\\\"ce_catalog_title\\\":\\\"PAW Patrol: PAWsome Adventures!\\\",\\\"ce_product_type\\\":\\\"Digital Download\\\",\\\"ce_price\\\":\\\"$7.50\\\",\\\"ce_strike\\\":\\\"\\\",\\\"ce_sale\\\":\\\"\\\",\\\"ce_pdp_title\\\":\\\"PAW Patrol: PAWsome Adventures!\\\",\\\"ce_cart_title\\\":\\\"PAW Patrol: PAWsome Adventures!\\\",\\\"ce_pdp_type\\\":\\\"Learning Game\\\"},\\\"vin_acc\\\":{\\\"vin_username\\\":\\\"leapfrog_admin\\\",\\\"vin_password\\\":\\\"M6v1X5o\\\"}}','2015-04-23 03:56:21','2015-04-23 03:56:21');"
  end

  def down
    say 'SQAAUTO-1110 [F6Q1_S10] ATG configuration - Store the ATG data in the database'

    say 'Delete new \'pins\' table'
    drop_table :pins

    say 'Delete new \'atg_configurations\' table'
    drop_table :atg_configurations
  end
end
