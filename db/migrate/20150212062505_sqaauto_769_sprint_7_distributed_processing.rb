class Sqaauto769Sprint7DistributedProcessing < ActiveRecord::Migration
  def up
    say "Create 'stations' table"
    create_table :stations, id: false do |t|
      t.string :network_name, null: false
      t.string :station_name
      t.string :ip
      t.integer :port
      t.datetime :created_at
      t.datetime :updated_at
    end
    add_index :stations, :network_name, unique: true
  end

  def down
    say "Drop 'stations' table"
    drop_table :stations
  end
end
