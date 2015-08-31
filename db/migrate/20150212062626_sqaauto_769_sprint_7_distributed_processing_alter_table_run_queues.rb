class Sqaauto769Sprint7DistributedProcessingAlterTableRunQueues < ActiveRecord::Migration
  def up
    say 'SQAAUTO-769 Distributed processing'
    say 'Add location field for "run_queues"'
    add_column :run_queues, :location, :string, after: :data
  end

  def down
    say 'Remove location field for "run_queues"'
    remove_column :run_queues, :location
  end
end
