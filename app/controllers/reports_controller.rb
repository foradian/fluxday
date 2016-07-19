class ReportsController < ApplicationController
  layout 'less_pane'


  def index
  end

  def activities
  end

  def employees_daily
    @opts = []
    if current_user.manager?
      @opts = [['Department', 'project'], ['Team', 'team'], ['Managing users', 'managing_users'], ["All employees", 'all_users'], ['Self', 'user']]
    else
      @opts << ['Department', 'project'] if current_user.admin_projects_count.to_i > 0
      @opts << ['Team', 'team'] if current_user.admin_teams_count.to_i > 0
      @opts << ['Managing users', 'managing_users'] if current_user.user_ids.length > 0
      @opts << ['Self', 'user']
    end
    @report_type = params[:report][:type] if params[:report].present?
    @report_type ||= current_user.manager? ? 'all_users' : 'user'
    if @report_type == 'project' && params[:report].present? && params[:report][:project_id].present?
      @projects = current_user.projects
      @project = current_user.manager? ? Project.find(params[:report][:project_id]) : @projects.find(params[:report][:project_id])
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
      tasks = Task.joins(:key_results).where('tasks.start_date <= ? && tasks.end_date >= ? && key_results.user_id in (?) && project_id = ?', @date.end_of_day, @date.beginning_of_day, @users.collect(&:id), @project.id).uniq
      grouped_tasks = tasks.group_by(&:user_ids)
    elsif @report_type == 'team'
      tasks = Task.joins(:key_results).where('tasks.start_date <= ? && tasks.end_date >= ? && key_results.user_id in (?) && team_id = ?', @date.end_of_day, @date.beginning_of_day, @users.collect(&:id), @team.id).uniq
      grouped_tasks = tasks.group_by(&:user_ids)
    else
      tasks = Task.joins(:key_results).where('tasks.start_date <= ? && tasks.end_date >= ? && key_results.user_id in (?)', @date.end_of_day, @date.beginning_of_day, @users.collect(&:id)).uniq
      grouped_tasks = tasks.group_by(&:user_ids)
    end
    grouped_tasks.keys.each { |x| x.each { |y| @tasks[y]=grouped_tasks[x] } }
    @work_logs = Hash.new { |h, k| h[k] = Hash.new(&h.default_proc) }
    work_logs = WorkLog.where(date: @date, user_id: @users.collect(&:id), task_id: tasks.collect(&:id)).select('id', 'user_id', 'minutes').group_by(&:user_id)
    work_logs.each { |x, v| @work_logs[x]="#{v.sum(&:minutes).to_duration}" }
    #work_logs.keys.each{|x| @work_logs[x]="#{work_logs[x].sum(&:minutes).to_i/60}:#{work_logs[x].sum(&:minutes).to_i%60}"}
    if ['csv', 'xls'].include?(request.format)
      @titles = ["Name", "Task", "Total hours"]
      @fields=[]
      @users.each do |user|
        @fields << ["#{user.name}", "#{@tasks[user.id].length}", "#{@work_logs[user.id] == {} ? "0:00" : @work_logs[user.id].to_i.to_duration}"]
      end
    end
    respond_to do |format|
      format.js { render :layout => false }
      format.html
      format.csv do
        response.headers['Content-Disposition'] = 'attachment; filename="okr_report.csv"'
        render "reports/csv_report.csv.erb"
      end
      format.xls do
        response.headers['Content-Disposition'] = 'attachment; filename="okr_report.xls"'
        render "reports/excel_report.xls.erb"
      end
      format.pdf { render :pdf => "Fluxday report", :page_size => 'A4', :show_as_html => params[:debug].present?, :disable_javascript => false, :layout => 'pdf.html', :footer => {:center => '[page] of [topage]'} }
    end
  end

  def employees_time_range
    @opts = []
    if current_user.manager?
      @opts = [['Department', 'project'], ['Team', 'team'], ['Managing users', 'managing_users'], ["All employees", 'all_users'], ['Self', 'user']]
    else
      @opts << ['Department', 'project'] if current_user.admin_projects_count.to_i > 0
      @opts << ['Team', 'team'] if current_user.admin_teams_count.to_i > 0
      @opts << ['Managing users', 'managing_users'] if current_user.user_ids.length > 0
      @opts << ['Self', 'user']
    end
    @report_type = params[:report][:type] if params[:report].present?
    @report_type ||= current_user.manager? ? 'all_users' : 'user'
    if @report_type == 'project' && params[:report].present? && params[:report][:project_id].present?
      @projects = current_user.projects
      @projects = Project.active if current_user.manager?
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
    @tasks= {} #Hash.new { |h, k| h[k] = Hash.new(&h.default_proc) }
    if @report_type == 'project'
      tasks = Task.joins(:key_results).where('project_id = ? && tasks.start_date <= ? && tasks.end_date >= ? && key_results.user_id in (?)', @project.id, @end_date.end_of_day, @start_date.beginning_of_day, @users.collect(&:id)).includes(:users).uniq
      grouped_tasks = tasks.group_by(&:user_ids)
    elsif @report_type == 'team'
      tasks = Task.joins(:key_results).where('team_id = ? && tasks.start_date <= ? && tasks.end_date >= ? && key_results.user_id in (?)', @team.id, @end_date.end_of_day, @start_date.beginning_of_day, @users.collect(&:id)).includes(:users).uniq
      grouped_tasks = tasks.group_by(&:user_ids)
    else
      tasks = Task.joins(:key_results).where('tasks.start_date <= ? && tasks.end_date >= ? && key_results.user_id in (?)', @end_date.end_of_day, @start_date.beginning_of_day, @users.collect(&:id)).includes(:users).uniq
      grouped_tasks = tasks.group_by(&:user_ids)
    end
    grouped_tasks.keys.each { |x| x.each { |y| @tasks[y]= @tasks[y].to_i + grouped_tasks[x].length } }
    @work_logs = Hash.new { |h, k| h[k] = Hash.new(&h.default_proc) }
    work_logs = WorkLog.where(date: @start_date..@end_date, user_id: @users.collect(&:id), task_id: tasks.collect(&:id)).select('id', 'user_id', 'minutes').group_by(&:user_id)
    work_logs.each { |x, v| @work_logs[x]="#{v.sum(&:minutes).to_i.to_duration}" }
    #work_logs.keys.each{|x| @work_logs[x]="#{work_logs[x].sum(&:minutes).to_i/60}:#{work_logs[x].sum(&:minutes).to_i%60}"}
    if ['csv', 'xls'].include?(request.format)
      @titles = ["Name", "Task", "Total hours"]
      @fields=[]
      @users.each do |user|
        @fields << ["#{user.name}", "#{@tasks[user.id].to_i}", "#{@work_logs[user.id] == {} ? "0:00" : @work_logs[user.id].to_i.to_duration}"]
      end
    end
    respond_to do |format|
      format.js { render :layout => false }
      format.html
      format.csv do
        response.headers['Content-Disposition'] = 'attachment; filename="okr_report.csv"'
        render "reports/csv_report.csv.erb"
      end
      format.xls do
        response.headers['Content-Disposition'] = 'attachment; filename="okr_report.xls"'
        render "reports/excel_report.xls.erb"
      end
      format.pdf { render :pdf => "Fluxday report", :page_size => 'A4', :show_as_html => params[:debug].present?, :disable_javascript => false, :layout => 'pdf.html', :footer => {:center => '[page] of [topage]'} }
    end
  end


  def employee_day
    if current_user.manager?
      @users = User.active
    else
      @users = ([current_user]+current_user.users).uniq
    end
    @user=User.find(params[:employee_id]) if params[:employee_id]
    @user ||= @users.first
    @date = params[:start_date].to_date if  params[:start_date].present?
    @date ||= Date.today
    @work_logs = WorkLog.where(date: @date, user_id: @user.id).includes(:task => [:project, :team])
    if ['csv', 'xls'].include?(request.format)
      @titles = ["Task", "Department", "Team", "Hours", "Status"]
      @fields=[]
      @work_logs.each do |log|
        @fields << ["#{log.task.name}", "#{log.task.project.name}", "#{log.task.team.name}", "#{log.hours}", "#{log.task.status == 'active' ? 'Pending' : log.task.status.capitalize}"]
      end
    end
    respond_to do |format|
      format.js { render :layout => false }
      format.html
      format.csv do
        response.headers['Content-Disposition'] = 'attachment; filename="okr_report.csv"'
        render "reports/csv_report.csv.erb"
      end
      format.xls do
        response.headers['Content-Disposition'] = 'attachment; filename="okr_report.xls"'
        render "reports/excel_report.xls.erb"
      end
      format.pdf { render :pdf => "Fluxday report", :page_size => 'A4', :show_as_html => params[:debug].present?, :disable_javascript => false, :layout => 'pdf.html', :footer => {:center => '[page] of [topage]'} }
    end
  end

  def employee_range
    if current_user.manager?
      @users = User.active
    else
      @users = ([current_user]+current_user.users).uniq
    end
    @user=User.find(params[:employee_id]) if params[:employee_id]
    @user ||= @users.first
    @start_date = params[:start_date].to_date if  params[:start_date].present?
    @start_date ||= Date.today.beginning_of_month
    @end_date = params[:end_date].to_date if  params[:end_date].present?
    @end_date ||= Date.today.end_of_month
    @work_logs = Hash.new { |h, k| h[k] = Hash.new(&h.default_proc) }
    work_logs = WorkLog.where(date: @start_date..@end_date, user_id: @user.id)
    logs = work_logs.group_by(&:task_id)
    @tasks = Task.where(id: logs.keys).includes([:project, :team])
    logs.each { |x, v| @work_logs[x]="#{v.sum(&:minutes).to_i.to_duration}" }
    @total={}
    @total['tasks']=@tasks.count
    @total['projects']=@tasks.collect(&:project_id).uniq.count
    @total['teams']=@tasks.collect(&:team_id).uniq.count
    @total['hours']="#{work_logs.sum('minutes').to_duration}"
    if ['csv', 'xls'].include?(request.format)
      @titles = ["Task", "Department", "Team", "Hours", "Status"]
      @fields=[]
      @tasks.each do |t|
        @fields << ["#{t.name}", "#{t.project.name}", "#{t.team.name}", "#{@work_logs[t.id]}", "#{t.status == 'active' ? 'Pending' : t.status.capitalize}"]
      end
    end
    respond_to do |format|
      format.js { render :layout => false }
      format.html
      format.csv do
        response.headers['Content-Disposition'] = 'attachment; filename="okr_report.csv"'
        render "reports/csv_report.csv.erb"
      end
      format.xls do
        response.headers['Content-Disposition'] = 'attachment; filename="okr_report.xls"'
        render "reports/excel_report.xls.erb"
      end
      format.pdf { render :pdf => "Fluxday report", :page_size => 'A4', :show_as_html => params[:debug].present?, :disable_javascript => false, :layout => 'pdf.html', :footer => {:center => '[page] of [topage]'} }
    end
  end


  def get_selection_list
    if params['type'] == 'project'
      @projects = current_user.manager? ? Project.active : current_user.projects
    elsif params['type'] == 'team'
      @teams = Team.for_user(current_user)
    elsif params['type'] == 'managing_user'
      @users = current_user.users
    elsif params['type'] == 'users'
      @users = (current_user.users + current_user.admin_teams.collect(&:users).flatten.uniq + current_user.projects.collect(&:users).flatten.uniq).uniq
    elsif params['type'] == 'user'

    end
  end

  def tasks
    unless (current_user.admin_teams_count.to_i + current_user.admin_projects_count.to_i) > 0
      redirect_to root_path, :alert => 'Nothing to show'
    else
      if current_user.manager?
        @opts = [['Department', 'project'], ['Team', 'team'], ['Users', 'users']]
      else
        @opts = []
        @opts << ['Department', 'project'] # if current_user.admin_projects_count.to_i > 0
        @opts << ['Team', 'team'] if current_user.admin_teams_count.to_i > 0
        @opts << ['Users', 'users'] if (current_user.user_ids.length > 0 || current_user.admin_teams_count.to_i > 0)
      end

      @report_type = params[:report][:type] if params[:report].present?
      @report_type ||= 'project'
      @start_date = params[:start_date].to_date if  (params[:report].present? && params[:start_date].present?)
      @end_date = params[:end_date].to_date if  (params[:report].present? && params[:end_date].present?)
      @start_date ||= Date.today.beginning_of_month
      @end_date ||= Date.today.end_of_month
      if @report_type == 'project'
        @projects = current_user.manager? ? Project.active : current_user.projects
        @project = @projects.find(params[:report][:project_id]) if (params[:report] && params[:report][:project_id])
        @project ||= @projects.first
        @tasks = Task.where('start_date <= ? && end_date >= ? && project_id = ?', @end_date.end_of_day, @start_date.beginning_of_day, @project.id).includes([:users, :project, :team]) if @project
      elsif @report_type == 'team'
        @teams = Team.for_user(current_user)
        @team=Team.find(params[:report][:team_id]) if (params[:report] && params[:report][:team_id])
        @tasks = Task.where('start_date <= ? && end_date >= ? && team_id = ?', @end_date.end_of_day, @start_date.beginning_of_day, @team.id).includes([:users, :project, :team]) if @team
      elsif @report_type == 'users'
        @user=User.find(params[:report][:user_id]) if (params[:report] && params[:report][:user_id])
        @tasks = @user.assignments.where('tasks.start_date <= ? && tasks.end_date >= ? ', @end_date.end_of_day, @start_date.beginning_of_day).includes([:users, :project, :team])
      end
      @work_logs = {} #Hash.new { |h, k| h[k] = Hash.new(&h.default_proc) }
      @assignees = {} #Hash.new { |h, k| h[k] = Hash.new(&h.default_proc) }
      #TaskAssignee.where(task_id: @tasks.collect(&:id)).group_by(&:task_id).map { |k, v| @assignees[k] = v.count }
      if @tasks.present?
        @tasks.each { |x| @assignees[x.id] = x.user_ids.length }
        work_logs = WorkLog.where(date: @start_date..@end_date, task_id: @tasks.collect(&:id))
        logs = work_logs.group_by(&:task_id)
        logs.each { |x, v| @work_logs[x]="#{v.sum(&:minutes).to_i.to_duration}" }
      end
      if ['csv', 'xls'].include?(request.format)
        @titles = ["Task", "Department", "Team", "Employees", "Hours", "Status"]
        @fields=[]
        @tasks.each do |task|
          @fields << ["#{task.name}", "#{task.project.name}", "#{task.team.name}", "#{@assignees[task.id].to_i}", "#{@work_logs[task.id]}", "#{task.status == 'active' ? 'Pending' : task.status.capitalize}"]
        end
      end
      respond_to do |format|
        format.js { render :layout => false }
        format.html
        format.csv do
          response.headers['Content-Disposition'] = 'attachment; filename="okr_report.csv"'
          render "reports/csv_report.csv.erb"
        end
        format.xls do
          response.headers['Content-Disposition'] = 'attachment; filename="okr_report.xls"'
          render "reports/excel_report.xls.erb"
        end
        format.pdf { render :pdf => "Fluxday report", :page_size => 'A4', :show_as_html => params[:debug].present?, :disable_javascript => false, :layout => 'pdf.html', :footer => {:center => '[page] of [topage]'} }
      end
    end
  end

  def employee_tasks
    @task = Task.find(params[:task_id])
    @users = @task.users
    @user = User.find(params[:user_id])
    @start_date = params[:start_date].to_date if params[:start_date].present?
    @end_date = params[:end_date].to_date if  params[:end_date].present?
    @start_date ||= Date.today.beginning_of_month
    @end_date ||= Date.today.end_of_month
    @work_logs = WorkLog.where(date: @start_date..@end_date, task_id: @task.id, user_id: @user.id)
    if ['csv', 'xls'].include?(request.format)
      @titles = ["Date", "Total Hours", "Description"]
      @fields=[]
      @work_logs.each do |log|
        @fields << ["#{log.date.strftime('%b %d, %Y %H:%M')}", "#{log.hours}", "#{log.description}"]
      end
    end
    respond_to do |format|
      format.js { render :layout => false }
      format.html
      format.csv do
        response.headers['Content-Disposition'] = 'attachment; filename="okr_report.csv"'
        render "reports/csv_report.csv.erb"
      end
      format.xls do
        response.headers['Content-Disposition'] = 'attachment; filename="okr_report.xls"'
        render "reports/excel_report.xls.erb"
      end
      format.pdf { render :pdf => "Fluxday report", :page_size => 'A4', :show_as_html => params[:debug].present?, :disable_javascript => false, :layout => 'pdf.html', :footer => {:center => '[page] of [topage]'} }
    end
  end

  def task
    unless (current_user.admin_teams_count.to_i + current_user.admin_projects_count.to_i) > 0
      redirect_to root_path, :alert => 'Nothing to show'
    else
      if params[:id].present?
        @task = current_user.log_viewable_tasks.find(params[:id])
      elsif  params[:tracker_id].present?
        @task = current_user.log_viewable_tasks.find_by_tracker_id(params[:tracker_id])
      end
      if @task.present?
        if params[:user_id].present?
          @logs = @task.work_logs.where(:user_id => params[:user_id]).includes(:user).order('date asc')
        else
          @logs = @task.work_logs.includes(:user).order('date asc')
        end
        @stats={}
        @stats['users'] = @logs.collect(&:user_id).uniq.count
        @stats['days'] = @logs.collect(&:date).uniq.count
        @stats['time'] = @logs.sum('minutes').to_duration
        if ['csv', 'xls'].include?(request.format)
          @titles = ["Date", "Employee", "Hours", "Description"]
          @fields=[]
          @logs.each do |log|
            @fields << ["#{log.date}", "#{log.user.name}", "#{log.hours}", "#{log.description}"]
          end
        end
        respond_to do |format|
          format.js { render :layout => false }
          format.html
          format.csv do
            response.headers['Content-Disposition'] = 'attachment; filename="okr_report.csv"'
            render "reports/csv_report.csv.erb"
          end
          format.xls do
            response.headers['Content-Disposition'] = 'attachment; filename="okr_report.xls"'
            render "reports/excel_report.xls.erb"
          end
          format.pdf { render :pdf => "Fluxday report", :page_size => 'A4', :show_as_html => params[:debug].present?, :disable_javascript => false, :layout => 'pdf.html', :footer => {:center => '[page] of [topage]'} }
        end
      else
        respond_to do |format|
          format.js { render :layout => false }
          format.html { redirect_to root_path, :alert => 'Unauthorized access' }
        end
      end
    end
  end

  def okrs
    @start_date = params[:start_date] if params[:start_date]
    @start_date ||= Date.today.to_quarters[0]
    @end_date = params[:end_date] if params[:end_date]
    @end_date ||= Date.today.to_quarters[1]
    if current_user.manager?
      @users = User.active
    else
      @users = ([current_user]+current_user.users).uniq
    end
    @user = User.find(params[:employee_id]) if params[:employee_id]
    @user ||= @users.first
    unless @users.include?(@user)
      redirect_to root_path, :alert => 'Unauthorized access'
    else
      @key_results = KeyResult.where(user_id: @user.id).active.includes(:task_key_results => [:task], :objective => :okr)
      #@tasks = Task.where(id:@key_results.collect(&:task_ids).flatten.uniq).includes(:)
      task_ids = @key_results.collect(&:task_ids).flatten
      tasks = Task.where("id IN (?) AND end_date >= ? and start_date <= ? ", task_ids,@start_date.to_date.beginning_of_day, @end_date.to_date.end_of_day)
      @tasks = {}
      @key_results.each { |k| @tasks[k.id] = tasks.where(id: k.task_ids) }
      work_logs = @user.work_logs.where(task_id: tasks.collect(&:id)).group_by(&:task_id)
      @work_logs ={}
      work_logs.each { |k, v| @work_logs[k] = v.sum(&:minutes).to_i.to_duration }
      if ['csv', 'xls'].include?(request.format)
        @titles = ["Task", "OKR", "Objective", "Key result", "Hours", "Status"]
        @fields=[]
        @key_results.each do |k|
          unless @tasks[k.id].nil?
            @tasks[k.id].each do |task|
              @fields << ["#{task.name}", "#{k.objective.okr.name}", "#{k.objective.name}", "#{k.name}", "#{@work_logs[task.id]}", "#{task.status == 'active' ? 'Pending' : task.status.capitalize}"]
            end
          end
        end
      end
      respond_to do |format|
        format.js { render :layout => false }
        format.html
        format.csv do
          response.headers['Content-Disposition'] = 'attachment; filename="okr_report.csv"'
          render "reports/csv_report.csv.erb"
        end
        format.xls do
          response.headers['Content-Disposition'] = 'attachment; filename="okr_report.xls"'
          render "reports/excel_report.xls.erb"
        end
        format.pdf { render :pdf => "Fluxday report", :page_size => 'A4', :show_as_html => params[:debug].present?, :disable_javascript => false, :layout => 'pdf.html', :footer => {:center => '[page] of [topage]'} }
      end
    end
  end


  def worklogs
    if params[:month].present? && params[:year].present?
      date = "01 #{params[:month]} #{params[:year]}".to_date
    else
      date = Date.today
    end
    @opts = []
    if current_user.manager?
      @opts = [['Department', 'project'], ['Team', 'team'], ['Managing users', 'managing_users'], ["All employees", 'all_users'], ['Self', 'user']]
    else
      @opts << ['Department', 'project'] if current_user.admin_projects_count.to_i > 0
      @opts << ['Team', 'team'] if current_user.admin_teams_count.to_i > 0
      @opts << ['Managing users', 'managing_users'] if current_user.user_ids.length > 0
      @opts << ['All accesible users', 'accessible']
      @opts << ['Self', 'user']
    end

    @report_type = params[:report][:type] if params[:report].present?
    @report_type ||= current_user.manager? ? 'all_users' : 'accessible'
    if @report_type == 'project' && params[:report].present? && params[:report][:project_id].present?
      @projects = current_user.projects
      @projects = Project.active if current_user.manager?
      @project = @projects.find(params[:report][:project_id])
      @users = @project.members if @project.present?
    elsif @report_type == 'team' && params[:report].present? && params[:report][:team_id].present?
      @team = Team.find(params[:report][:team_id])
      @users = @team.members
    elsif @report_type == 'managing_users'
      @users = current_user.users
    elsif @report_type == 'all_users'
      @users = User.active
    elsif @report_type == 'accessible'
      @users = current_user.accessible_users
    elsif @report_type == 'employees' && params[:report].present? && params[:report][:user_id].present?
      @users = User.where(id: params[:report][:user_id])
    else
      @users = User.where(id: current_user.id)
    end

    @start_date = date.beginning_of_month
    @end_date = date.end_of_month
    #@users = current_user.accessible_users
    worklogs = WorkLog.where(date: @start_date..@end_date, user_id: @users.collect(&:id)).select('id', 'user_id', 'minutes', 'date', 'task_id', 'description','delete_request').includes(:task) #.group_by(&:user_id)
    @hours = Hash.new { |h, k| h[k] = Hash.new(&h.default_proc) }
    if params[:detailed].present? && params[:detailed]
      @user_logs = Hash.new { |h, k| h[k] = Hash.new(&h.default_proc) }
      @user_rows = {}
      worklogs.map { |x| (@user_logs[x.user_id][x.date.day].is_a?(Hash) ? @user_logs[x.user_id][x.date.day]=[] : @user_logs[x.user_id][x.date.day]) << [x.minutes.to_duration, "#{x.task.name} - #{x.description}" ] }
      @user_logs.each { |k, v| @user_rows[k]=v.values.map { |x| x.length }.max }
    end
    worklogs.map { |x| @hours[x.user_id][x.date.day]['hours'] = @hours[x.user_id][x.date.day].to_s.to_i + x.minutes;(x.delete_request == true ? @hours[x.user_id][x.date.day]['delete_request'] = true : (x.delete_request == false and @hours[x.user_id][x.date.day]['delete_request'] != true) ? @hours[x.user_id][x.date.day]['delete_request'] = false : @hours[x.user_id][x.date.day]['delete_request'] = true)}
    @total = {}
    @average = {}
    @users.map { |u| @total[u.id] = @hours[u.id]['hours'].values.sum }
    @users.map { |u| @average[u.id] = (@total[u.id].to_s.to_f/(@end_date-@start_date)).to_i.to_duration }
    if ['csv', 'xls'].include?(request.format)
      @titles = ["Name"]
      @titles += (@start_date..@end_date).map { |x| x.day }.sort
      @titles << "Average"
      @titles << "Total"
      @fields=[]
      @users.each do |user|
        row = []
        row << user.name
        row += (@start_date..@end_date).map { |dt| @hours[user.id][dt.day].blank? ? "-" : @hours[user.id][dt.day]["hours"].to_duration }
        row << @average[user.id]
        row << @total[user.id].to_duration
        @fields << row
      end
    end
    respond_to do |format|
      format.js { render :layout => false }
      format.html
      format.csv do
        response.headers['Content-Disposition'] = 'attachment; filename="worklog.csv"'
        render "reports/csv_report.csv.erb"
      end
      format.xls do
        if params[:detailed].present? && params[:detailed]
          p @hours.inspect
          response.headers['Content-Disposition'] = 'attachment; filename="worklog_detailed.xls"'
          render "reports/worklog_detailed.xls.erb"
        else
          response.headers['Content-Disposition'] = 'attachment; filename="worklog.xls"'
          render "reports/excel_report.xls.erb"
        end
      end
      format.pdf { render :pdf => "Fluxday worklog report", :page_size => 'A4', :orientation => 'landscape', :show_as_html => params[:debug].present?, :disable_javascript => false, :layout => 'pdf.html', :footer => {:center => '[page] of [topage]'} }
    end
  end



  def day_log
    @date = params[:date].to_date if params[:date]
    @date ||= Date.today
    @user = current_user.accessible_users.friendly.where(employee_code: params[:user_id]) if params[:user_id]
    @user = @user.first if @user.present?
    @work_logs = @user.work_logs.where(date: @date).includes(:task) if @user.present?
    unless @user.present?
      respond_to do |format|
        format.js { render :layout => false }
        flash[:notice] = "Permission denied"
        format.html { redirect_to root_path }
      end
    else
      if ['csv', 'xls'].include?(request.format)
        @titles = ["Task", "Duration", "Description"]
        @fields=[]
        @work_logs.each do |log|
          @fields << ["#{log.task.name}", "#{log.minutes.to_duration}", "#{log.description}"]
        end
      end
      respond_to do |format|
        format.js { render :layout => false }
        format.html
        format.csv do
          response.headers['Content-Disposition'] = 'attachment; filename="worklog.csv"'
          render "reports/csv_report.csv.erb"
        end
        format.xls do
          response.headers['Content-Disposition'] = 'attachment; filename="worklog.xls"'
          render "reports/excel_report.xls.erb"
        end
        format.pdf { render :pdf => "Fluxday Daily report", :page_size => 'A4', :show_as_html => params[:debug].present?, :disable_javascript => false, :layout => 'pdf.html', :footer => {:center => '[page] of [topage]'} }
      end
    end
  end

  def assignments
    @users = current_user.accessible_users
    if params[:user_id]
      @user = @users.where(id: params[:user_id])
      @user = @user.first if @user
    else
      @user = current_user
    end
    @titles = ["Task", "Description", "Start date", "End date", "Status", "Time spent"]
    @fields=[]
    if @user.present?
      #quarter = params[:quarter] if params[:quarter]
      #year = params[:fin_year] if params[:fin_year]
      #if quarter && year
      #  year = year.to_i+1 if quarter == 'q1'
      #  case quarter
      #  when 'q1'
      #    month = 'Jan'
      #  when 'q2'
      #    month = 'Apr'
      #  when 'q3'
      #    month = 'Jul'
      #  when 'q4'
      #    month = 'Oct'
      #  end
      #  date = "01 #{month} #{year}".to_date
      #else
      #date = Date.today
      #end
      @start_date = params[:start_date] if params[:start_date]
      @start_date ||= Date.today.to_quarters[0]
      @end_date = params[:end_date] if params[:end_date]
      @end_date ||= Date.today.to_quarters[1]
      #@range = date.to_quarters
      #tasks=@user.assignments.where('tasks.start_date <= ? && tasks.end_date >= ?',@range[1],@range[0])
      tasks=@user.assignments.where('tasks.start_date <= ? && tasks.end_date >= ?', @end_date, @start_date)
      logs = @user.work_logs.where(task_id: tasks).group_by(&:task_id)
      tasks.each do |t|
        @fields << [
            "#{t.tracker_id}",
            "#{t.name}",
            #"#{t.description}",
            "#{t.start_date.strftime('%b %d, %Y %H:%M')}",
            "#{t.end_date.strftime('%b %d, %Y %H:%M')}",
            "#{t.status == 'active' ? 'Pending' : t.status.capitalize}",
            "#{t.completed_on.nil? ? '' : t.completed_on.strftime('%b %d, %Y %H:%M')}",
            "#{logs[t.id].nil? ? '0:00' : logs[t.id].sum(&:minutes).to_duration }"
        ]
      end
      respond_to do |format|
        format.js { render :layout => false }
        format.html
        format.csv do
          response.headers['Content-Disposition'] = 'attachment; filename="assignments.csv"'
          render "reports/csv_report.csv.erb"
        end
        format.xls do
          response.headers['Content-Disposition'] = 'attachment; filename="assignments.xls"'
          render "reports/excel_report.xls.erb"
        end
        format.pdf { render :pdf => "Fluxday Assignments", :page_size => 'A4', :show_as_html => params[:debug].present?, :disable_javascript => false, :layout => 'pdf.html', :footer => {:center => '[page] of [topage]'} }
      end
    else
      respond_to do |format|
        format.js { render :layout => false }
        flash[:notice] = "Permission denied"
        format.html { redirect_to root_path }
      end
    end

  end


  protected

  def redirect_for_unauthorized(users, user)
    unless users.include?(users)
      redirect_to root_path, :alert => 'Unauthorized access'
    end
  end
end
