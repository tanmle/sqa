class Sqaauto1242F6q2S12TestcentralIndexJsonBlobs1 < ActiveRecord::Migration
  def up
    say '[F6Q2_S12] TestCentral - index json blobs - update runs table text blob to json column type, add generated columns and index'

    add_column :runs, :data_temp, :json
    execute 'update runs set data_temp = convert(data using utf8)'
    remove_column :runs, :data
    rename_column :runs, :data_temp, :data
  end

  def down
    sql = <<-SQL
      alter table runs add column data_blob longblob;
      update runs set data_blob = data;
      alter table runs drop column data;
      alter table runs change column data_blob data longblob;
    SQL
    sql.lines.each { |x| execute x unless x.blank? }
  end
end
