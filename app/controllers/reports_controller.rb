class ReportsController < ApplicationController
  layout 'less_pane'


  def index
  end

  def activities
  end

  def employees_daily
    @report_type = params[:report_type]
    @report_type ||= 'default'
    if @report_type == 'project' && params[:project_id].present?
      @project = Project.find(params[:project_id])
      @users = @project.members
    elsif @report_type == 'team' &&  params[:team_id].present?
      @team = Team.find(params[:team_id])
      @users = @team.members
    elsif @report_type == 'employees' && params[:user_ids].present?
      @users = User.where(id: params[:user_ids])
    elsif @report_type == 'employees' && params[:user_id].present?
      @users = User.where(id: params[:user_id])
    else
      @users = User.where(id: current_user.id)
    end
    @date = params[:date] if params[:date].present?
    @date ||= Date.today
    @tasks=Hash.new { |h, k| h[k] = Hash.new(&h.default_proc) }
    tasks = Task.joins(:task_assignees).where('start_date <= ? && end_date >= ? && task_assignees.user_id in (?)', @date.end_of_day, @date.beginning_of_day,@users.collect(&:id)).group_by(&:user_ids)
    tasks.keys.each{|x| x.each{|y| @tasks[y]=tasks[x] }}
    @work_logs = Hash.new { |h, k| h[k] = Hash.new(&h.default_proc) }
    work_logs = WorkLog.where(date:@date,user_id:@users.collect(&:id)).select('id','user_id','minutes').group_by(&:user_id)
    work_logs.each{|x,v| @work_logs[x]="#{v.sum(&:minutes).to_i/60}:#{v.sum(&:minutes).to_i%60}"}
    #work_logs.keys.each{|x| @work_logs[x]="#{work_logs[x].sum(&:minutes).to_i/60}:#{work_logs[x].sum(&:minutes).to_i%60}"}
  end
end
