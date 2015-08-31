class Sqaauto338CheckOutWithNewAccountByUsingCreditCard < ActiveRecord::Migration
  def up
    say "SQAAUTO-338 Failed TC01_1: Check out with a new account by using Credit card - ENV = 'UAT' - Locale = 'US'"

    @connection = ActiveRecord::Base.connection

    say 'Update data for \'atg_credit\' table'
    @connection.execute "UPDATE `atg_credit` SET card_type = 'Visa' WHERE card_type = 'Visa Purchasing Card III'"
  end
end
