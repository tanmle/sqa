class Sqaauto332ImplementImportingYamlFileToDatabaseFunction < ActiveRecord::Migration
  def down
    remove_column :ep_titles, :ymal
    remove_column :atg_moas, :ymal
  end
  
  def up
    say 'schema changes'
    add_column :ep_titles, :ymal, :string, :limit => 200
    add_column :atg_moas, :ymal, :string, :limit => 200
  end
end
