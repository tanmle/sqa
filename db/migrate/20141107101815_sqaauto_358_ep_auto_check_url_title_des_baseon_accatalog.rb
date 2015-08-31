class Sqaauto358EpAutoCheckUrlTitleDesBaseonAccatalog < ActiveRecord::Migration
  def up
    say 'SQAAUTO-358 EP Automation: Check URL, Title, Description based on file AppCenterCatalog.xlsx'

    say 'Insert data for \'cases\' table'
    Case.create(id: 338, name: 'SEO checking', description: '', script_path: 'seo/seo_checking.rb')   

    say 'Insert data for \'suites\' table'
    Suite.create(id: 54, name: 'EP SEO checking', description: 'EP Automation: Check URL, Title, Description based on file AppCenterCatalog.xlsx', silo_id: 3, order: 54)

    say 'Insert data for \'case_suite_maps\' table'
    CaseSuiteMap.create(suite_id: 54, case_id: 338, order: 338)
  end
end
