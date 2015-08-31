class SchedulerController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def index
    sch_lst = Schedule.all.order(next_run: :asc)
    @content = ''
    sch_lst.each do |sch|
      @content += sch.to_html true
    end
  end

  def update_scheduler_status
    Thread.new do
      Schedule.new.update_status(params[:id], params[:status])
      Schedule.new.run_schedule
    end
    redirect_to action: 'index'
  end

  def update_scheduler_location
    Thread.new do
      Schedule.new.update_location(params[:id], params[:location])
      Schedule.new.run_schedule
    end
    redirect_to action: 'index'
  end

  def update_scheduler
    dow = params[:dow].nil? ? '' : params[:dow].join(',')
    validate = Schedule.new.validate_params(params[:start_time], params[:repeat], params[:minute], dow, params[:user_email])

    if validate.blank?
      update_status = Schedule.new.update_schedule(params[:id], params[:note], params[:start_time], params[:minute], dow, params[:user_email], session[:user_email])
      if update_status.blank?
        flash[:success] = 'Thank you! Your Schedule Test has been updated successful.'
        Thread.new { Schedule.new.run_schedule }
      else
        flash[:error] = update_status.html_safe
      end
    else
      flash[:error] = validate.html_safe
    end

    redirect_to action: 'index'
  end
end
