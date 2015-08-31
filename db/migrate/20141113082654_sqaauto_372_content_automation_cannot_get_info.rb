class Sqaauto372ContentAutomationCannotGetInfo < ActiveRecord::Migration
  def up
    say 'SQAAUTO-372 - Update test suite id for test case cabo 286, 287'
    (286..287).each { |n| CaseSuiteMap.where(case_id: n).update_all(suite_id: 46)}
  end
end
