class Sqaauto958AtgContentSearchPdpCheckingFixVerifyCreditLinkExists < ActiveRecord::Migration
  def up
    say 'SQAAUTO-958 [Q1_S9] ATG Content - search pdp checking - fix verify credit link exists'

    say 'Add "baseassetname" column to atg_moas_fr table"'
    add_column :atg_moas_fr, :baseassetname, :string, null: false
  end

  def down
    say 'Remove "baseassetname" column to atg_moas_fr table"'
    remove_column :atg_moas_fr, :baseassetname
  end
end
