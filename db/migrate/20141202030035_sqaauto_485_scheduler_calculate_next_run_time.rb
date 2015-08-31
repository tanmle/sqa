class Sqaauto485SchedulerCalculateNextRunTime < ActiveRecord::Migration
  def up
    say 'SQAAUTO-485 Scheduler - calculate next run time'

    say 'Add more column onto table Schedulers'
    add_column :schedules, :next_run, :datetime, after: :weekly
  end

  def down
    remove_column :schedules, :next_run
  end
end
