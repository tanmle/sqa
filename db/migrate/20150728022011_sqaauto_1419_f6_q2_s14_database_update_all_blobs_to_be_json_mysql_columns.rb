class Sqaauto1419F6Q2S14DatabaseUpdateAllBlobsToBeJsonMysqlColumns < ActiveRecord::Migration
  def update_json_column(table, column)
    add_column table, :temp_column, :json, after: column
    execute "UPDATE #{table.to_s} SET temp_column = CONVERT(#{column.to_s} using utf8)"
    remove_column table, column
    rename_column table, :temp_column, column
  end

  def update_blob_column(table, column)
    sql = <<-SQL
      alter table #{table} add column data_blob blob after #{column};
      update #{table} set data_blob = #{column};
      alter table #{table} drop column #{column};
      alter table #{table} change column data_blob #{column} blob;
    SQL
    sql.lines.each { |x| execute x unless x.blank? }
  end

  def up
    say '[F6Q2_S14] Database - Update all Blobs to be Json MYSQL columns'
    tables = [
      [:atg_configurations, :data],
      [:env_versions, :services],
      [:outposts, :available_tests],
      [:run_queues, :data],
      [:schedules, :data],
      [:tc_release_notes, :notes]
    ]

    tables.each do |table|
      say "Update #{table[0]}(#{table[1]}) table"
      update_json_column table[0], table[1]
    end

    say 'Update silos(data) table -> Remove column'
    remove_column :silos, :data
  end

  def down
    say '[F6Q2_S14] Database - Update all Blobs to be Json MYSQL columns'

    tables = [
      ['atg_configurations', 'data'],
      ['env_versions', 'services'],
      ['outposts', 'available_tests'],
      ['run_queues', 'data'],
      ['schedules', 'data'],
      ['tc_release_notes', 'notes']
    ]

    tables.each do |table|
      say "Update #{table[0]}(#{table[1]}) table"
      update_blob_column table[0], table[1]
    end

    say 'Update silos(data) table'
    add_column :silos, :data, :binary
  end
end
