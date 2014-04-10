class HomeController < ApplicationController
  def index
    if current_user.present?
      dashboard
      render 'home/dashboard'
    else

    end
  end

  def dashboard
    date = params[:date].present? ? parama[:date].to_date : Date.today
    @start_date = date - 6.days#.beginning_of_week
    @end_date = @start_date+6.days#.end_of_week
    @entry_hash={}
    #entries = Task.where('start_date <= ? && end_date >= ?',@end_date.end_of_day,@start_date.beginning_of_day)
    entries = current_user.work_logs.where('date <= ? && date >= ?', @end_date.end_of_day, @start_date.beginning_of_day)
    (@start_date..@end_date).each do |dt|
      @entry_hash[dt] = entries.where('date <= ? && date >= ?', dt.end_of_day, dt.beginning_of_day)
    end
    unless params[:date].present?
      @date = Date.today
    else
      @date = params[:date].to_date
    end
    @entries = current_user.assigned_and_written_tasks.where('start_date <= ? && end_date >= ?', @date.end_of_day, @date.beginning_of_day)
    @work_logs = current_user.work_logs.find_all_by_date(@date)
  end

  def search
    @task = Task.searchable_for_user(current_user).find_by_tracker_id(params[:search][:keyword])
    if @task.present?
      redirect_to :controller=>'tasks',:action=>'show',:id=>@task.tracker_id
    else
      @tasks = Task.searchable_for_user(current_user).search('tracker_id_or_name_or_description_cont'=>params[:search][:keyword]).result.paginate(page: params[:page], per_page: 10).order('id DESC')
      #render :layout => 'less_pane'
    end
  end
end
