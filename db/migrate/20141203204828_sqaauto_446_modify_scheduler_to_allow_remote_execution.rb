class Sqaauto446ModifySchedulerToAllowRemoteExecution < ActiveRecord::Migration
  def up
    add_column :schedules, :location, :string
  end
  def down
    remove_column :schedules, :location
  end
end
