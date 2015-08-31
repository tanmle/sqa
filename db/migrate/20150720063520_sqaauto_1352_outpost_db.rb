class Sqaauto1352OutpostDb < ActiveRecord::Migration
  def up
    say "Create 'outposts' table"
    create_table :outposts do |t|
      t.string 'name', limit: 100, null: false
      t.string 'silo', limit: 50, null: false
      t.string 'ip', null: false
      t.string 'status'
      t.string 'status_url'
      t.string 'exec_url'
      t.binary 'available_tests'
      t.datetime 'created_at'
      t.datetime 'updated_at'
      t.datetime 'checked_at'
    end

    add_index :outposts, :name, unique: true
  end

  def down
    say "Drop 'outposts' table"
    drop_table :outposts
  end
end
