class Sqaauto1072TcMoasImportTheDataTooLongForColumnLfdescDisplaysWhenImportingMoasWithDataMoreThan1000Characters < ActiveRecord::Migration
  def up
    say "SQAAUTO-1072 TC - MOAS Import - The 'Data too long for column lfdesc...' displays when importing MOAS with data more than 1000 characters"
    change_column :atg_moas_fr, :lfdesc, :string, :limit => 2000
    change_column :atg_moas, :lfdesc, :string, :limit => 2000
  end
end
