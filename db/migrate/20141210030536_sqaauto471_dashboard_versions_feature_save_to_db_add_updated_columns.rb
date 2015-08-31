class Sqaauto471DashboardVersionsFeatureSaveToDbAddUpdatedColumns < ActiveRecord::Migration
  def down
    remove_column :env_versions, :updated_at
  end

  def up
    say 'SQAAUTO-471 [Sprint_4] Dashboard versions - feature - save to db'
    
    say 'Add "updated_at" column to env_versions table"'
    add_column :env_versions, :updated_at, :datetime
  end
end
