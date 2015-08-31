class Sqaauto402ContentAutomationAtgEnUpdateProcessOfDescriptionOnesentence < ActiveRecord::Migration
  def up
    say "SQAAUTO-402 CONTENT Automation: ATG EN: Update process: LF Description or One-Sentence Description information can also displays as long description in PDP of app"

    say "Add 'onesentence' column to 'atg_moas' table"
    add_column :atg_moas, :onesentence, :string, after: :lfdesc, default: '', limit: 500
  end

  def down
    remove_column :atg_moas, :onesentence
  end
end
