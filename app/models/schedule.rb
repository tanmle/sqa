require 'json'

class Schedule < ActiveRecord::Base
  include PublicActivity::Common
  serialize :data, ApplicationHelper::JSONWithIndifferentAccess
  @@mutex = Mutex.new

  def init_schedules
    Thread.new { exec_testcentral_test }
    Thread.new { run_schedule }
    Thread.new { exec_outpost_test }
  end

  def add_schedule(silo, note, data, start_time, minute, weekly, user_id, location, status = 1)
    current_time = Time.now.in_time_zone
    start_date = "#{current_time.year}-#{current_time.month}-#{current_time.day} #{start_time}".to_time

    next_run = ''
    next_run = calculate_next_run(start_time, minute) unless minute.blank?
    next_run = start_date if minute.blank? && weekly.blank?

    @schedule = Schedule.new(
      name: silo.upcase,
      description: note,
      data: data,
      start_date: start_date,
      repeat_min: minute,
      weekly: weekly,
      next_run: next_run,
      status: status,
      user_id: user_id,
      location: location
    )

    return 'Error while adding schedule. Please try again!' unless @schedule.save

    @schedule.create_activity key: 'schedule.create', owner: User.find(user_id)

    ''
  rescue => e
    "Error while adding schedule: #{e.message}"
  end

  def update_schedule(id, note, start_time, minute, weekly, emaillist, user_email)
    current_time = Time.now.in_time_zone
    start_date = "#{current_time.year}-#{current_time.month}-#{current_time.day} #{start_time}".to_time

    if minute
      next_run = calculate_next_run(start_time, minute)
    elsif weekly.blank?
      next_run = start_date
    else
      next_run = ''
    end

    scheduler = Schedule.find id
    scheduler.start_date = start_date
    scheduler.repeat_min = minute
    scheduler.weekly = weekly
    scheduler.next_run = next_run
    scheduler.description = note
    scheduler.data['emaillist'] = emaillist

    return 'Error while updating schedule, please try again!' unless scheduler.save

    Rails.logger.info "Updated scheduler ID ##{id} to: note => #{note}, start_time => #{start_time}, minute => #{minute}, weekly => #{weekly}"
    scheduler.create_activity key: 'schedule.update', owner: User.find_by(email: user_email)

    ''
  rescue => e
    "Error while updating schedule: #{e.message}"
  end

  def run_schedule
    return unless Rails.application.config.server_role.blank?
    $scheduler.jobs.each(&:unschedule)
    threads = []
    Rails.logger.info "Run Scheduler - CurrentTime: #{Time.now}"

    active_schedules = Schedule.where(status: 1)
    active_schedules.each do |sch|
      if sch.weekly.blank? && sch.repeat_min.blank?
        date_time_format = '%Y-%m-%d %H:%M:00'
        current_time = Time.now.strftime(date_time_format)
        time_to_run = sch.start_date.strftime(date_time_format)

        if current_time < time_to_run
          Schedule.update(sch.id, next_run: sch.start_date)
          $scheduler.at time_to_run do
            Rails.logger.info 'One-time event'
            threads << Thread.new { add_queue(sch) }
          end
        else
          if sch.status == 1
            Schedule.delete(sch.id)
            Rails.logger.info "Delete expired one-time-schedule ID: #{sch.id}"
          end
        end
      elsif sch.repeat_min.blank?
        time_to_repeat = "#{sch.start_date.strftime('%M %H')} * * #{sch.weekly}"
        Schedule.update(sch.id, next_run: Rufus::Scheduler.parse(time_to_repeat).next_time)
        $scheduler.cron time_to_repeat do |job|
          Rails.logger.info 'Execute weekly'
          threads << Thread.new { add_queue(sch) }
          Schedule.update(sch.id, next_run: job.next_time)
        end
      else
        min = sch.repeat_min.to_s + 'm'
        sch_next_run = calculate_next_run(sch.start_date, sch.repeat_min)
        Schedule.update(sch.id, next_run: sch_next_run)
        $scheduler.every min, first_at: sch_next_run do
          Rails.logger.info 'Repeat by minute'
          threads << Thread.new { add_queue(sch) }
        end
      end
    end
    threads.map(&:join)
    $scheduler.join
  end

  def add_queue(sch)
    @@mutex.synchronize do
      if sch.repeat_min
        Schedule.update(sch.id, next_run: calculate_next_run(sch.start_date, sch.repeat_min))
      elsif sch.weekly.blank?
        Schedule.delete(sch.id)
      end

      # Don't add to run queue if previously scheduled is still in queue
      unless Run.run_queue_by_schedule_id(sch.id).blank?
        Rails.logger.info "Don\'t add to run queue because the previously scheduled is still in queue: ID ##{sch.id}"
        return
      end

      begin
        # Get data from table then parse it to necessary info
        data = sch.data
        silo = data[:silo].blank? ? sch.name.upcase : data[:silo]
        user_email = User.get_user_info_by_id(sch.user_id)[:email]

        execute_data = {
          silo: silo,
          browser: data[:browser],
          env: data[:env],
          locale: data[:locale],
          testsuite: data[:testsuite],
          testcases: data[:testcases],
          releasedate: data[:releasedate],
          data_driven_csv: data[:data_driven_csv],
          device_store: data[:device_store],
          payment_type: '',
          emaillist: data[:emaillist],
          schedule_info: {
            id: sch.id.to_s,
            description: sch.description,
            start_date: sch.start_date,
            repeat_min: sch.repeat_min,
            weekly: sch.weekly,
            user_email: user_email
          }
        }

        # Generate multiple run data with payment_type
        execute_data_list = []
        payment_type_arr = data[:payment_type]

        if payment_type_arr.blank?
          execute_data_list << execute_data
        else # Generate multiple run from Locale and Payment Type
          data[:locale].each do |locale|
            payment_type_arr.each do |type|
              execute_data.merge!(
                locale: locale,
                payment_type: type
              )
              execute_data_list << execute_data.clone
            end
          end
        end

        execute_data_list.each do |run_data|
          station = Station.assign_station sch.location
          run = Run.create(
            data: run_data,
            location: station,
            user_id: sch.user_id,
            status: 'queued'
          )

          Rails.logger.info "Add schedule to run: ID ##{run.id}"
        end
      rescue => e
        Rails.logger.info "Error while adding schedule to run: #{ModelCommon.full_exception_error e}"
      ensure
        begin
          ActiveRecord::Base.connection.close if ActiveRecord::Base.connection && ActiveRecord::Base.connection.active?
        rescue => e
          Rails.logger.info "Error while closing ActiveRecord db connection: #{ModelCommon.full_exception_error e}"
        end
      end
    end
  end

  def update_status(id, status)
    Rails.logger.info "Update status of schedulerID #{id} to: #{status}"
    Schedule.update(id, next_run: nil) if status.to_i == 0
    schedule = Schedule.update(id, status: status)
    schedule.create_activity key: 'schedule.status.update', owner: User.current_user
  end

  def update_location(id, location)
    schedule = Schedule.update(id, location: location)
    schedule.create_activity key: 'schedule.location.update', owner: User.current_user
  end

  def validate_params(start_time, repeat, minutes, dow, emaillist = nil)
    error = ''
    begin
      start_time.to_datetime.strftime('%M %H %p')
    rescue
      error = 'Incorrect Start Time format'
    end
    error = 'You can not choose both \'By minutes\' and \'By day of week\'' if !minutes.blank? && !dow.blank? && repeat == 'on'
    error = 'You should choose one repeat option' if minutes.blank? && dow.blank? && repeat == 'on'

    return error unless emaillist

    emails = emaillist.split(/[,;]/)
    emails = [''] if emails.blank?
    emails.each do |email|
      error << 'Email can not be blank and should have format: example@abc.com<br/>' if email.blank? || !(email =~ /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i)
    end

    error
  end

  def calculate_next_run(start_time, repeat_min)
    return start_time unless repeat_min.is_a? Integer
    current_time = Time.now.in_time_zone
    repeat_time = repeat_min * 60
    start_time += repeat_time.to_i while current_time > start_time
    start_time
  end

  def to_html_row
    to_html
  end

  def to_html(is_admin = false)
    format_time = Rails.application.config.time_format
    user_info = User.get_user_info_by_id(self[:user_id])
    user_name = user_info[:full_name]
    start_time = self[:start_date].strftime(format_time).split(' ')[2..3].join ' '

    if self[:repeat_min]
      repeat_time = self[:repeat_min].to_s + ' minute(s)'
    elsif self[:weekly] != ''
      repeat_time = ModelCommon.to_day_of_week self[:weekly]
    else
      repeat_time = 'one-time event'
    end

    if self[:status].zero?
      next_run = 'not enabled'
    elsif repeat_time == 'one-time event'
      next_run = self[:start_date].strftime(format_time)
    else
      next_run = self[:next_run].blank? ? '' : self[:next_run].strftime(format_time)
    end

    html_status = "ID #{self[:id]}"
    html_location = ''
    html_edit = ''

    if is_admin
      status = self[:status].zero? ? '' : 'checked'
      html_active = "<input type=\"checkbox\" name=\"active\" id=\"active\" value=#{self[:id]} #{status} onchange=\"update_scheduler_status(#{self[:id]}, this);\">"

      # generate location list
      location_list = Station.location_list('schedule')
      location_list[0][0] = 'DEFAULT'
      location_list.unshift ['ANY', 'ANY']

      helper = ActionController::Base.helpers
      html_location = "<td>#{helper.select_tag :location, helper.options_for_select(location_list, self[:location]), onchange: "update_scheduler_location('#{self[:id]}', this);"}</td>"
      html_status = "#{html_active} #{html_status}"
      html_edit = "<td>#{helper.link_to 'Edit', "\##{self[:id]}", onclick: "update_scheduler(#{self[:id]}, '#{self[:description]}', '#{start_time}', '#{self[:repeat_min]}', '#{self[:weekly]}', '#{self[:data]['emaillist']}');"}</td>"
    end

    # Display on Dashboard
    html_status_dashboard = "<td>#{html_status}</td>"
    html_runtime_dashboard = "<td>Every: #{repeat_time}<br>#{next_run}</td>"

    locale = data[:locale].is_a?(Array) ? data[:locale].join('_') : data[:locale]
    link_parts = [
      data[:silo],
      user_info[:email].split('@')[0],
      Suite.test_suite_name(data[:testsuite]),
      data[:env].to_s.upcase,
      locale,
      data[:releasedate].to_s
    ].reject { |n| n.nil? || n.empty? }.join('_')

    html_description_dashboard = "<td>User: #{user_name}<br>#{link_parts}"
    html_description_dashboard += "<br>Description: #{self[:description]}" unless self[:description].empty?
    html_description_dashboard += '</td>'

    '<tr class=\"bout\" style=\"font-weight: bold\">' + html_status_dashboard + html_runtime_dashboard + html_description_dashboard + html_location + html_edit + '</tr>'
  end

  def exec_testcentral_test
    $sch_execute_ts.jobs.each(&:unschedule)
    xml_content = Nokogiri::XML(File.read(RailsAppConfig.new.config_file))
    $limit_number = xml_content.search('//autoSetting/limitRunningTest').text.to_i
    $refresh_rate = xml_content.search('//autoSetting/refreshRunningRate').text.to_i
    Rails.logger.info "Scheduler running tests every #{$refresh_rate}s - CurrentTime: #{Time.now}"

    $sch_execute_ts.every "#{$refresh_rate}s", first_at: Time.now + $refresh_rate do
      begin
        location = Rails.application.config.server_name.to_s
        is_main_server = Station.all.order(:station_name, :created_at).first.network_name == location

        if is_main_server
          run = Run.where("status = 'queued' and (location = ? or location is null or location = '')", location).order(:created_at).first
        else
          run = Run.where(location: location, status: 'queued').order(:created_at).first
        end

        if !run.nil? && $count_progress < $limit_number
          run.update(status: 'running')
          run.exec_testcentral_testcase
        end
      rescue => e
        run.update(status: 'error') unless run.nil?
        Rails.logger.info "Exception scheduler running tests: #{ModelCommon.full_exception_error e}"
      ensure
        begin
          ActiveRecord::Base.connection.close if ActiveRecord::Base.connection && ActiveRecord::Base.connection.active?
        rescue => e
          Rails.logger.info "Exception closing ActiveRecord db connection: #{ModelCommon.full_exception_error e}"
        end
      end
    end
    $sch_execute_ts.join
  end

  def exec_outpost_test
    $sch_execute_outpost.jobs.each(&:unschedule)
    refresh_rate = 10
    Rails.logger.info "Scheduler execute Outpost every #{refresh_rate}s - CurrentTime: #{Time.now}"

    $sch_execute_outpost.every "#{refresh_rate}s", first_at: Time.now + refresh_rate do
      begin
        run = Run.where("status = 'queued' and location in (select name from outposts)").order(:created_at).first

        unless run.nil?
          run.update(status: 'running')
          run.exec_outpost_testcase
        end
      rescue => e
        run.update(status: 'error') unless run.nil?
        Rails.logger.info "Exception scheduler running tests: #{ModelCommon.full_exception_error e}"
      ensure
        begin
          ActiveRecord::Base.connection.close if ActiveRecord::Base.connection && ActiveRecord::Base.connection.active?
        rescue => e
          Rails.logger.info "Exception closing ActiveRecord db connection: #{ModelCommon.full_exception_error e}"
        end
      end
    end
    $sch_execute_outpost.join
  end
end
