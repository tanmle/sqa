class Sqaauto369MysqlServerErrorDataTooLongForColumnData < ActiveRecord::Migration
  def up
    say 'change data type of data field from Blob to LongBlob'

    update 'alter table `runs` modify `data` longblob'
  end
end
