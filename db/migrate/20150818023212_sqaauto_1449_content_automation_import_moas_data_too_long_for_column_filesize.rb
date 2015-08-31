class Sqaauto1449ContentAutomationImportMoasDataTooLongForColumnFilesize < ActiveRecord::Migration
  def up
    say "SQAAUTO-1449 [F6Q2_S15] CONTENT Automation: Import MOAS: 'Data too long for column filesize at row…' error message displays"

    say "Update the lenght of 'filesize' column of 'atg_moas' table to 300"
    update 'alter table `atg_moas` modify `filesize` varchar(300) not null'
  end

  def down
    update 'alter table `atg_moas` modify `filesize` varchar(100) not null'
  end
end
