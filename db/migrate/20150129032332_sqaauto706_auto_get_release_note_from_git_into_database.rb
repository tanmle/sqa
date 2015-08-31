class Sqaauto706AutoGetReleaseNoteFromGitIntoDatabase < ActiveRecord::Migration
  def up
    say "Create 'tc_release_notes' table"
    create_table :tc_release_notes do |t|
      t.binary 'notes'
      t.string 'release', limit: 100, null: false
      t.datetime 'updated_at'
    end
    add_index :tc_release_notes, :release, unique: true
  end

  def down
    say "Drop 'tc_release_notes' table"
    drop_table :tc_release_notes
  end
end
