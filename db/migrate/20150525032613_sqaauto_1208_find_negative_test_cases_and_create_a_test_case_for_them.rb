class Sqaauto1208FindNegativeTestCasesAndCreateATestCaseForThem < ActiveRecord::Migration
  def up
    say 'SQAAUTO-1208 Add Narnia negative test script'

    say 'Insert data for \'cases\' table'
    insert 'INSERT INTO `cases` VALUES (383,\'Narnia negative test cases\',\'Narnia negative test case\',\'8_Narnia/ts04_narnia_negative_test_cases.rb\',NULL,NULL);'

    say 'Insert data for \'case_suite_maps\' table'
    insert 'INSERT INTO `case_suite_maps` VALUES (376,63,383,NULL,NULL,408);'
  end
end
