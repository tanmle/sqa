class Sqaauto837CreateNewTestCaseToVerifyBaseAssetsInsertBaseAssetColumn < ActiveRecord::Migration
  def up
    say 'SQAAUTO-837 [Q1_S8] ATG Content - create new test case to verify base assets'

    say 'Add "baseassetname" column to atg_moas table"'
    add_column :atg_moas, :baseassetname, :string, null: false
  end
end
