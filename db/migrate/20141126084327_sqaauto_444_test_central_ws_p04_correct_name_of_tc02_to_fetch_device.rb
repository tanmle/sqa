class Sqaauto444TestCentralWsP04CorrectNameOfTc02ToFetchDevice < ActiveRecord::Migration
  def up
    say 'SQAAUTO-444 Test Central: WS: Inmon/P04-device-management: Correct the name of tc_02 to \'Fetch device\''
    
    say 'Update cases table - id:33 - name: Fetch device'
    Case.update(33, name: 'Fetch device')
  end
end
