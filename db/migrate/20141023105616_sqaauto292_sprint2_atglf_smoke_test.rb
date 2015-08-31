class Sqaauto292Sprint2AtglfSmokeTest < ActiveRecord::Migration
  def up
    say 'SQAAUTO-292 [Sprint_2] ATG/LF.com Smoke Test'

    say 'Insert data for \'cases\' table'
    Case.create(id: 321, name: 'ATG/LF set up customer ', description: '', script_path: '8_atg_lf.com_smoke_test/atg_lfcom_smoke_test.rb')   

    say 'Insert data for \'suites\' table'
    Suite.create(id: 51, name: 'ATG/LF.com Smoke Test', description: 'ATG/LF.com Smoke Test support holiday testing', silo_id: 2, order: 51)

    say 'Insert data for \'case_suite_maps\' table'
    CaseSuiteMap.create(suite_id: 51, case_id: 321, order: 321)
  end
end
