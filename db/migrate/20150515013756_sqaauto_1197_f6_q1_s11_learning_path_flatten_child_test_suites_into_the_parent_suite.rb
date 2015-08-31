class Sqaauto1197F6Q1S11LearningPathFlattenChildTestSuitesIntoTheParentSuite < ActiveRecord::Migration
  def up
    say 'SQAAUTO-1197 [F6Q1_S11] Learning Path - Flatten child test suites into the parent suite'

    say 'Update Test case name'
    update "UPDATE cases SET `name` = 'P01 Parent API - fetch parent' where id = 120"
    update "UPDATE cases SET `name` = 'P01 Parent API - update parent' where id = 121"
    update "UPDATE cases SET `name` = 'P01 Parent API - fetch children' where id = 122"
    update "UPDATE cases SET `name` = 'P01 Parent API - create parent' where id = 123"
    update "UPDATE cases SET `name` = 'P02 Child API - fetch child' where id = 124"
    update "UPDATE cases SET `name` = 'P02 Child API - fetch child goals' where id = 125"
    update "UPDATE cases SET `name` = 'P02 Child API -  update child goal' where id = 126"
    update "UPDATE cases SET `name` = 'P03 Milestones API - fetch milestones' where id = 127"
    update "UPDATE cases SET `name` = 'P03 Milestones API - fetch milestones details' where id = 128"
    update "UPDATE cases SET `name` = 'P04 Goals APIs - fetch goals' where id = 129"
    update "UPDATE cases SET `name` = 'P05 WeeklyContent API - fetch weekly content for baby center model' where id = 130"
    update "UPDATE cases SET `name` = 'P05 WeeklyContent API - fetch weekly content for milestone model' where id = 131"
    update "UPDATE cases SET `name` = 'P06 Discussions API - fetch discussions' where id = 132"
    update "UPDATE cases SET `name` = 'P07 SSO API - login' where id = 133"
    update "UPDATE cases SET `name` = 'P07 SSO API - reset password' where id = 134"
    update "UPDATE cases SET `name` = 'P07 SSO API - change password' where id = 135"
    update "UPDATE cases SET `name` = 'P08 SetupAPI - fetch setup info' where id = 136"

    say 'Delete Child suites'
    delete 'DELETE FROM suites WHERE `id` >= 27 and id <= 34'
    delete 'DELETE FROM suite_maps WHERE `parent_suite_id` = 26'

    say 'Map test cases to Parent suite'
    update 'UPDATE case_suite_maps SET `suite_id` = 26 WHERE `case_id` >= 120 and `case_id` <= 136'
  end
end
