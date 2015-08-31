class Sqaauto1363F6Q2S13ContentAutomationFailToImportMoasWithDataOnMiscnotesColumnTooLong < ActiveRecord::Migration
  def up
    say 'SQAAUTO-1363 [F6Q2_S13] CONTENT Automation: Fail to import MOAS with data on "miscnotes" column too long'

    say "Update the lenght of 'highlights' column of 'atg_moas' table to 200"
    update 'alter table `atg_moas` modify `miscnotes` varchar(1000) not null'
  end

  def down
    update 'alter table `atg_moas` modify `miscnotes` varchar(800) not null'
  end
end
