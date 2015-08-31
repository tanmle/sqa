require 'spec_helper'

class ScheduleUnitTest
  describe 'Run Schedule Checking' do
    context 'TC01 - Add new some ATG schedules into schedules table' do
      it 'Add new ATG schedule - repeat minutes' do
        schedule_count = Schedule.count
        Schedule.new.add_schedule('ATG', 'run ATG', "{silo: 'ATG',browser:'FIREFOX',env:'UAT',locale:'US',testsuite:'43',testcases:'219,226',releasedate: '',emaillist:'ltrc_vn@leapfrog.test',description:''}", '2015-01-12 00:01:00'.to_datetime, 30, '', 6, '')
        expect(Schedule.count).to eq(schedule_count + 1)
      end

      it 'Add new ATG schedule - repeat weekly' do
        schedule_count = Schedule.count
        Schedule.new.add_schedule('ATG', 'run ATG', "{silo: 'ATG',browser:'FIREFOX',env:'UAT',locale:'US',testsuite:'43',testcases:'219,226',releasedate: '',emaillist:'ltrc_vn@leapfrog.test',description:''}", '2015-01-12 00:01:00'.to_datetime, '', '2,4,6', 6, '')
        expect(Schedule.count).to eq(schedule_count + 1)
      end

      after :all do
        Schedule.destroy_all(data: "{silo: 'ATG',browser:'FIREFOX',env:'UAT',locale:'US',testsuite:'43',testcases:'219,226',releasedate: '',emaillist:'ltrc_vn@leapfrog.test',description:''}")
      end
    end

    context 'TC02 - Add new some EP schedules into schedules table' do
      it 'Add new EP schedule - repeat minutes' do
        schedule_count = Schedule.count
        Schedule.new.add_schedule('EP', 'run EP', "{silo: 'EP',browser:'FIREFOX',env:'qa',locale:'',testsuite:'41',testcases:'201',releasedate: '2014-12-31',emaillist:'ltrc_vn@leapfrog.test',description:''}", '2015-01-19 00:01:00'.to_datetime, 25, '', 4, '')
        expect(Schedule.count).to eq(schedule_count + 1)
      end

      it 'Add new EP schedule - repeat weekly' do
        schedule_count = Schedule.count
        Schedule.new.add_schedule('EP', 'run EP', "{silo: 'EP',browser:'FIREFOX',env:'qa',locale:'',testsuite:'41',testcases:'201',releasedate: '2014-12-31',emaillist:'ltrc_vn@leapfrog.test',description:''}", '2015-01-19 00:01:00'.to_datetime, '', '3,5,7', 4, '')
        expect(Schedule.count).to eq(schedule_count + 1)
      end

      after :all do
        Schedule.destroy_all(data: "{silo: 'EP',browser:'FIREFOX',env:'qa',locale:'',testsuite:'41',testcases:'201',releasedate: '2014-12-31',emaillist:'ltrc_vn@leapfrog.test',description:''}")
      end
    end

    context 'TC03 - Add new some WS schedules into schedules table' do
      it 'Add new WS schedule - repeat minutes' do
        schedule_count = Schedule.count
        Schedule.new.add_schedule('WS', 'run WS', "{silo: 'WS',browser:'',env:'QA',locale:'',testsuite:'25',testcases:'113',releasedate: '',emaillist:'ltrc_vn@leapfrog.test',description:'run WS'}", '2015-01-12 00:01:00'.to_datetime, 30, '', 5, '')
        expect(Schedule.count).to eq(schedule_count + 1)
      end

      it 'Add new WS schedule - repeat weekly' do
        schedule_count = Schedule.count
        Schedule.new.add_schedule('WS', 'run WS', "{silo: 'WS',browser:'',env:'QA',locale:'',testsuite:'25',testcases:'113',releasedate: '',emaillist:'ltrc_vn@leapfrog.test',description:'run WS'}", '2015-01-12 00:01:00'.to_datetime, '', '1,2,3,4,5', 5, '')
        expect(Schedule.count).to eq(schedule_count + 1)
      end

      after :all do
        Schedule.destroy_all(data: "{silo: 'WS',browser:'',env:'QA',locale:'',testsuite:'25',testcases:'113',releasedate: '',emaillist:'ltrc_vn@leapfrog.test',description:'run WS'}")
      end
    end
  end
end
