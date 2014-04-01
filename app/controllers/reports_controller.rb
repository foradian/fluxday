class ReportsController < ApplicationController
  layout 'less_pane'


  def index
  end

  def activities
  end

  def employees_daily
    @report_type = params[:report][:type] if params[:report].present?
    @report_type ||= current_user.manager? ? 'all_users' : 'user'
    if @report_type == 'project' && params[:report].present? && params[:report][:project_id].present?
      @projects = current_user.projects
      @project = @projects.find(params[:report][:project_id])
      @users = @project.members if @project.present?
    elsif @report_type == 'team' && params[:report].present? && params[:report][:team_id].present?
      @team = Team.find(params[:report][:team_id])
      @users = @team.members
    elsif @report_type == 'managing_users'
      @users = current_user.users
    elsif @report_type == 'all_users'
      @users = User.active
    elsif @report_type == 'employees' && params[:report].present? && params[:report][:user_id].present?
      @users = User.where(id: params[:report][:user_id])
    else
      @users = User.where(id: current_user.id)
    end
    @date = params[:report][:date].to_date if  (params[:report].present? && params[:report][:date].present?)
    @date ||= Date.today
    @tasks=Hash.new { |h, k| h[k] = Hash.new(&h.default_proc) }
    if @report_type == 'project'
      tasks = Task.joins(:task_assignees).where('start_date <= ? && end_date >= ? && task_assignees.user_id in (?) && project_id = ?', @date.end_of_day, @date.beginning_of_day, @users.collect(&:id), @project.id)
      grouped_tasks = tasks.group_by(&:user_ids)
    elsif @report_type == 'team'
      tasks = Task.joins(:task_assignees).where('start_date <= ? && end_date >= ? && task_assignees.user_id in (?) && team_id = ?', @date.end_of_day, @date.beginning_of_day, @users.collect(&:id), @team.id)
      grouped_tasks = tasks.group_by(&:user_ids)
    else
      tasks = Task.joins(:task_assignees).where('start_date <= ? && end_date >= ? && task_assignees.user_id in (?)', @date.end_of_day, @date.beginning_of_day, @users.collect(&:id))
      grouped_tasks = tasks.group_by(&:user_ids)
    end
    grouped_tasks.keys.each { |x| x.each { |y| @tasks[y]=grouped_tasks[x] } }
    @work_logs = Hash.new { |h, k| h[k] = Hash.new(&h.default_proc) }
    work_logs = WorkLog.where(date: @date, user_id: @users.collect(&:id), task_id: tasks.collect(&:id)).select('id', 'user_id', 'minutes').group_by(&:user_id)
    work_logs.each { |x, v| @work_logs[x]="#{v.sum(&:minutes).to_i/60}:#{v.sum(&:minutes).to_i%60}" }
    #work_logs.keys.each{|x| @work_logs[x]="#{work_logs[x].sum(&:minutes).to_i/60}:#{work_logs[x].sum(&:minutes).to_i%60}"}
  end

  def employees_time_range
    @report_type = params[:report][:type] if params[:report].present?
    @report_type ||= current_user.manager? ? 'all_users' : 'user'
    if @report_type == 'project' && params[:report].present? && params[:report][:project_id].present?
      @projects = current_user.projects
      @project = @projects.find(params[:report][:project_id])
      @users = @project.members if @project.present?
    elsif @report_type == 'team' && params[:report].present? && params[:report][:team_id].present?
      @team = Team.find(params[:report][:team_id])
      @users = @team.members
    elsif @report_type == 'managing_users'
      @users = current_user.users
    elsif @report_type == 'all_users'
      @users = User.active
    elsif @report_type == 'employees' && params[:report].present? && params[:report][:user_id].present?
      @users = User.where(id: params[:report][:user_id])
    else
      @users = User.where(id: current_user.id)
    end
    @start_date = params[:report][:start_date].to_date if  (params[:report].present? && params[:report][:start_date].present?)
    @end_date = params[:report][:end_date].to_date if  (params[:report].present? && params[:report][:end_date].present?)
    @start_date ||= Date.today.beginning_of_month
    @end_date ||= Date.today.end_of_month
    @tasks=Hash.new { |h, k| h[k] = Hash.new(&h.default_proc) }
    if @report_type == 'project'
      tasks = Task.joins(:task_assignees).where('project_id = ? && start_date <= ? && end_date >= ? && task_assignees.user_id in (?)', @project.id,@end_date.end_of_day, @start_date.beginning_of_day, @users.collect(&:id))
      grouped_tasks = tasks.group_by(&:user_ids)
    elsif @report_type == 'team'
      tasks = Task.joins(:task_assignees).where('team_id = ? && start_date <= ? && end_date >= ? && task_assignees.user_id in (?)', @team.id,@end_date.end_of_day, @start_date.beginning_of_day, @users.collect(&:id))
      grouped_tasks = tasks.group_by(&:user_ids)
    else
      tasks = Task.joins(:task_assignees).where('start_date <= ? && end_date >= ? && task_assignees.user_id in (?)', @end_date.end_of_day, @start_date.beginning_of_day, @users.collect(&:id))
      grouped_tasks = tasks.group_by(&:user_ids)
    end
    grouped_tasks.keys.each { |x| x.each { |y| @tasks[y]=grouped_tasks[x] } }
    @work_logs = Hash.new { |h, k| h[k] = Hash.new(&h.default_proc) }
    work_logs = WorkLog.where(date: @start_date..@end_date, user_id: @users.collect(&:id), task_id: tasks.collect(&:id)).select('id', 'user_id', 'minutes').group_by(&:user_id)
    work_logs.each { |x, v| @work_logs[x]="#{v.sum(&:minutes).to_i/60}:#{v.sum(&:minutes).to_i%60}" }
    #work_logs.keys.each{|x| @work_logs[x]="#{work_logs[x].sum(&:minutes).to_i/60}:#{work_logs[x].sum(&:minutes).to_i%60}"}
  end



  def employee_day
    @user=User.find(params[:employee_id])
    @date = params[:start_date].to_date if  params[:start_date].present?
    @date ||= Date.today
    @work_logs = WorkLog.where(date: @date, user_id: @user.id).includes(:task=>[:project,:team])
  end

  def employee_range
    @user=User.find(params[:employee_id])
    @start_date = params[:start_date].to_date if  params[:start_date].present?
    @start_date ||= Date.today.beginning_of_month
    @end_date = params[:end_date].to_date if  params[:end_date].present?
    @end_date ||= Date.today.end_of_month
    @work_logs = Hash.new { |h, k| h[k] = Hash.new(&h.default_proc) }
    work_logs = WorkLog.where(date: @start_date..@end_date, user_id: @user.id)
    logs = work_logs.group_by(&:task_id)
    @tasks = Task.where(id:logs.keys).includes([:project,:team])
    logs.each { |x, v| @work_logs[x]="#{v.sum(&:minutes).to_i/60}:#{ '%02d' % (v.sum(&:minutes).to_i%60)}" }
    @total={}
    @total['tasks']=@tasks.count
    @total['projects']=@tasks.collect(&:project_id).uniq.count
    @total['teams']=@tasks.collect(&:team_id).uniq.count
    @total['hours']="#{work_logs.sum('minutes')/60}:#{work_logs.sum('minutes')%60}"
  end


  def get_selection_list
    if params['type'] == 'project'
      @projects = current_user.projects
    elsif params['type'] == 'team'
      @teams = Team.for_user(current_user)
    elsif params['type'] == 'managing_user'
      @users = current_user.users
    elsif params['type'] == 'user'

    end
  end
end
