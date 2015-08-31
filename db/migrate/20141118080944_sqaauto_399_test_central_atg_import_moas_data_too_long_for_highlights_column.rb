class Sqaauto399TestCentralAtgImportMoasDataTooLongForHighlightsColumn < ActiveRecord::Migration
  def up
    say "SQAAUTO-399 Test Central/ATG/Import Moas: The system responses 'Data too long for column 'highlights' at row ' message when importing moas file that has long content at 'highlights' column"

    say "Update the lenght of 'highlights' column of 'atg_moas' table to 200"
    update 'alter table `atg_moas` modify `highlights` varchar(200) not null'
  end

  def down
    update 'alter table `atg_moas` modify `highlights` varchar(100) not null'
  end
end
