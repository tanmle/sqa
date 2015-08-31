class Sqaauto333ImplementEpYmalChecking < ActiveRecord::Migration
  def up
    say 'SQAAUTO-333 Implement ep_ymal_checking.rb'

    say 'Insert data for \'cases\' table'
    Case.create(id: 337, name: 'YMAL checking', description: '', script_path: 'ymal/ep_ymal_checking.rb')   

    say 'Insert data for \'suites\' table'
    Suite.create(id: 53, name: 'YMAL checking', description: 'EP you may also like checking', silo_id: 3, order: 53)

    say 'Insert data for \'case_suite_maps\' table'
    CaseSuiteMap.create(suite_id: 53, case_id: 337, order: 337)
  end
end
