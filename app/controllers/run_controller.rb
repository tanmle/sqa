require 'active_support/core_ext/string/strip'
require 'json'

class RunController < ApplicationController
  attr_accessor :silo_name, :level

  def index
    @selected_silo = params['silo_name']
    @outpost_silos = Outpost.outpost_silo_options
    render 'run/index'
  end

  def show_run_silo
    @silo = params['sname']
    redirect_to 'dashboard/index' if @silo.blank?

    @outposts = Outpost.outposts @silo
    if @outposts.blank?
      @test_suites = Suite.test_suite_list(@silo, session[:user_role])
    else
      default_outpost = @outposts[0][0]
      @test_suites = Outpost.test_suite_list default_outpost
    end

    @atg = Atg.new
    @station_info = Station.location_list
    @station_info[0][1] = 'DEFAULT'
    @station_info.unshift ['ANY', 'ANY']
    @station_selected = @station_info[0]

    render 'run/run_component', layout: false
  end

  def view_silo_group
    @selected_silo = params['sname']
    @outpost_silos = Outpost.outpost_silo_options
    render 'run/view_silo_group'
  end

  def show_view_silo
    info = user_params
    silo = params['sname']

    @content = ''
    @level = user_params[:level]
    @outpost_silos = Outpost.outpost_silo_options
    @selected_silo = silo

    case @level
    when 0
      @content = silo_to_html silo
    when 1
      runs = Run.by_group_name silo, info[:view_path]
      return '' unless runs

      runs.each do |run|
        @content += view_group_html_row "#{info[:view_path]}/#{run.name_lvl2}", run, silo
      end
    else
      @test_script = []
      @running_summary = ''

      view_path_parts = user_params[:view_path_parts]
      runs = Run.by_group_name silo, view_path_parts[0]
      return if runs.blank?

      name_lvl2 = view_path_parts[1..(view_path_parts.length - 1)].join('/')
      run = runs.find { |x| x.name_lvl2 == name_lvl2 }
      return if run.blank?

      suite_name = run.data['suite_name']
      @running_summary = run.summary_html
      cases = run.data['cases']
      return if cases.blank?

      cases.each do |c|
        @test_script.push(run.case_row_data(c).merge! duration: c['duration'])
      end
    end

    @breadcrumbs = breadcrumbs_html info, silo, suite_name

    render 'run/view_component', layout: false
  end

  def add_queue
    current_user_id = User.find_by(email: session[:user_email]).id
    silo = params[:silo]
    browser = params[:webdriver].to_s
    env = params[:env].to_s
    locales = params[:locale]
    test_suites = params[:testsuite]
    test_cases = params[:testrun].nil? ? '' : params[:testrun].join(',')
    release_date = params[:release_date].to_s
    data_driven_csv = params[:data_driven_csv].blank? ? '' : ModelCommon.upload_and_get_data_driven_csv(params[:data_driven_csv])
    device_store = params[:device_store].to_s
    payment_types = params[:payment_type]
    description = params[:note].to_s
    emails = params[:user_email]
    station = params[:station]
    execute_data_lst = []

    execute_data = {
      silo: silo,
      browser: browser,
      env: env,
      locale: locales,
      testsuite: test_suites,
      testcases: test_cases,
      releasedate: release_date,
      data_driven_csv: data_driven_csv,
      device_store: device_store,
      payment_type: payment_types,
      emaillist: emails,
      description: description
    }

    case silo.upcase
    when 'ATG'
      if locales
        if payment_types.blank?
          locales.each do |locale|
            execute_data.merge! locale: locale
            execute_data_lst << execute_data.clone
          end
        else
          execute_data_lst << execute_data
        end
      else
        execute_data.merge! locale: ''
        execute_data_lst << execute_data
      end
    when 'WS'
      test_suites = test_suites.split(',')
      is_all_ts = test_suites.count > 1

      test_suites.each do |ts|
        test_cases = CaseSuiteMap.get_test_cases(ts).join(',') if is_all_ts
        execute_data.merge!(
          testsuite: ts,
          testcases: test_cases
        )
        execute_data_lst << execute_data.clone
      end
    else
      execute_data_lst << execute_data
    end

    if station.blank?
      location = Outpost.outpost_info(id: params[:outpost])[:name]
    else
      location = station
    end

    if params[:start_time].blank?
      created_at = Time.now.in_time_zone
      start_time = created_at + 60

      execute_data_lst.each do |data|
        if data[:payment_type].blank?
          station = Station.assign_station location
          Run.add_to_run_queue(data, station, created_at, current_user_id)
        else # Add 1-off schedule for 1 minute in the future
          Schedule.new.add_schedule(silo, description, data, start_time, nil, '', current_user_id, location)
          Thread.new { Schedule.new.run_schedule }
        end
      end

      flash[:success] = 'Thank you! You will get the result after Test Scripts have been executed completely.'
    else
      start_time = params[:start_time]
      repeat = params[:repeat]
      minute = params[:minute]
      date_of_week = params[:dow].nil? ? '' : params[:dow].join(',')
      validate = Schedule.new.validate_params(start_time, repeat, minute, date_of_week)

      unless validate.blank?
        flash[:error] = validate.html_safe
        redirect_to :back
        return
      end

      error = ''
      execute_data_lst.each do |data|
        error << Schedule.new.add_schedule(silo, description, data, start_time, minute, date_of_week, current_user_id, location)
      end

      if error.blank?
        flash[:success] = 'Thank you! Your Schedule Test has been added successful.'
      else
        flash[:error] = error.html_safe
      end

      Thread.new { Schedule.new.run_schedule }
    end

    redirect_to :back
  ensure
    begin
      ActiveRecord::Base.connection.close if ActiveRecord::Base.connection && ActiveRecord::Base.connection.active?
    rescue => e
      Rails.logger.error "Exception closing ActiveRecord db connection: #{ModelCommon.full_exception_error e}"
    end
  end

  def silo_to_html(silo)
    date = params[:date]
    if date
      start_date = DateTime.strptime(date, '%Y-%m')
    else
      start_date = Date.today.at_beginning_of_month
    end

    end_date = start_date + 1.months

    @current_date = start_date.strftime '%Y-%m'
    @previous_date = (start_date - 1.months).strftime '%Y-%m'
    @next_date = (start_date + 1.months).strftime '%Y-%m'
    @silo = silo

    groups = Run.by_silo_group silo, start_date, end_date

    groups.values.each do |value|
      value[:status] = Run.runs_css_class value[:runs]
    end

    groups = groups.sort.reverse

    html = ''
    groups.each do |group|
      count = group[1][:runs].size
      html += view_silo_html_row "#{group[0]} (#{count} #{'run'.pluralize count})", group[0], silo, group[1][:status]
    end
    html
  end

  def delete
    view_path_parts = user_params[:view_path_parts]
    level = user_params[:level]
    name_lvl1 = view_path_parts[0]
    silo = params[:sname]

    runs = []
    if level == 1
      groups = Run.by_silo_group silo
      runs = groups[name_lvl1][:runs] unless groups[name_lvl1].nil?
    else
      group_runs = Run.by_group_name silo, name_lvl1
      runs << group_runs.find { |x| x.name_lvl2 == view_path_parts[1..(view_path_parts.length - 1)].join('/') }
    end

    runs.each do |r|
      r.create_activity key: 'run.destroy', owner: User.current_user
      r.destroy
    end

    redirect_to :back
  end

  def user_params
    view_path = params[:view_path] || ''
    view_path.slice!(0) if view_path.start_with? '/'
    view_path_parts = view_path.split '/'
    level = view_path_parts.length

    {
      level: level,
      page: params[:date],
      sname: params[:sname],
      view_path: view_path,
      view_path_parts: view_path_parts
    }
  end

  def breadcrumbs_html(info, silo, suite_name)
    breadcrumbs = [{ title: silo, link: "/#{silo}/view" }]

    info[:view_path_parts].each_with_index do |n, i|
      path = info[:view_path_parts][0..i].join '/'
      title = i == 1 ? suite_name : n.tr('_', ' ')
      breadcrumbs << { title: title, link: "/#{silo}/view/#{path}" }
    end

    breadcrumbs.delete_at(breadcrumbs.length - 1) if info[:view_path].end_with?('.html')

    content = ''
    breadcrumbs.each_with_index do |n, i|
      is_end = i == (breadcrumbs.size - 1)
      content += '<small>' if i > 0
      content += "<a class=\"rp_body_a\" href=\"#{n[:link]}\">#{n[:title]}</a>"
      content += ' »' unless is_end
      content += '</small>' if i > 0
    end

    content
  end

  def download
    info = user_params
    run_ins = Run.new
    download_path = run_ins.create_zip_file info

    if File.directory? download_path
      send_file run_ins.zip_folder(download_path), type: 'application/zip', x_sendfile: true
    else
      redirect_to :back
    end
  end

  def download_file
    format = params[:format]
    file = "#{params[:file_path]}.#{format}"
    send_file Rails.root.join('public', file), type: "application/#{format}", x_sendfile: true
  end

  def view_result
    info = user_params
    silo = info[:sname]

    view_path_parts = info[:view_path_parts]
    file_name = view_path_parts[-1].gsub('.html', '.rb')

    runs = Run.by_group_name silo, view_path_parts[0]
    temp_lv2 = view_path_parts[1..-2].join('/')
    run = runs.find { |r| r.name_lvl2 == temp_lv2 }
    return '' unless run

    run.reload
    @case = run.case_to_html(file_name) || ''

    suite_name = run.data['suite_name']
    @breadcrumbs = breadcrumbs_html info, silo, suite_name

    render layout: true
  end

  def get_test_cases
    test_suite = params[:test_suite]
    outpost = params[:outpost]

    if outpost.blank?
      child_ts_ids = SuiteMap.where(parent_suite_id: test_suite).map(&:child_suite_id)
      child_ts = Suite.where('id in (?)', child_ts_ids).order(order: :asc).pluck(:id, :name)
      test_cases = []
      test_cases = Case.joins(:case_suite_maps).where(case_suite_maps: { suite_id: test_suite }).order('case_suite_maps.order asc').pluck(:case_id, :name) unless test_suite.split(',').size > 1

      if child_ts.size > 0 && test_cases.size == 0
        test_case_list = child_ts.unshift(['folder_type'], ['', '-- Select child test suite --'], [child_ts_ids, 'All test suites'])
      else
        test_case_list = test_cases.unshift(['file_type'])
      end
    else
      test_case_list = Outpost.test_case_list(outpost, test_suite).unshift(['file_type'])
    end

    render plain: test_case_list
  end

  def build_test_suite_from_outpost
    test_suites = Outpost.test_suite_list params[:outpost]

    options = ''
    test_suites.each do |ts|
      options << '<option value="' + ts[1] + '">' + ts[0].titleize + '</option>'
    end

    render plain: options
  end

  # GET /status/1.json
  def status
    render json: [$count_progress]
  end

  private

  def view_silo_html_row(name, path, silo, css_class)
    <<-INTERPOLATED_HEREDOC.strip_heredoc
    <tr class="bout">
      <td align="left" style="padding-left: 15px">
        <a #{css_class} href="/#{silo}/view/#{path}">#{name.tr('_', ' ')}</a>
      </td>
      <td width="7%" align="center"><a href="/#{silo}/download/#{path}">
        <img width="20" height="20" title="Download this folder" src="/assets/download_folder.png"></a>
      </td>
      <td width="7%" align="center">
        <a class="delete" href="/#{silo}/delete/#{path}">
          <img width="20" height="20" title="Delete this folder" src="/assets/delete_folder.png">
        </a>
      </td>
    </tr>
    INTERPOLATED_HEREDOC
  end

  def view_group_html_row(path, run, silo)
    <<-INTERPOLATED_HEREDOC.strip_heredoc
    <tr class="">
      <td align="left" style="padding-left: 15px">
        #{run.to_html}
      </td>
      <td>#{run.updated_at.strftime Rails.application.config.short_time_format}</td>
      <td width="7%" align="center"><a href="/#{silo}/download/#{path}">
        <img width="20" height="20" title="Download this folder" src="/assets/download_folder.png"></a>
      </td>
      <td width="7%" align="center">
        <a class="delete" href="/#{silo}/delete/#{path}">
          <img width="20" height="20" title="Delete this folder" src="/assets/delete_folder.png">
        </a>
      </td>
    </tr>
    INTERPOLATED_HEREDOC
  end
end
