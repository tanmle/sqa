class Sqaauto1176AgesCheckingRemoveCheckingForAgePageFrom9YearsTo12Years < ActiveRecord::Migration
  def up
    say 'SQAAUTO-1176 [F6Q1_S11] CONTENT Automation: ATG EN: Ages Checking: Request Automation remove checking for age page from 9 years to 12 years'
    @connection = ActiveRecord::Base.connection

    @connection.execute "delete from atg_filter_list where type = 'Age' and name IN ('9 years', '10 years', '11 years', '12 years')"
  end
end
