class WorkLogsController < ApplicationController
  before_action :set_work_log, only: [:show, :edit, :update, :destroy, :delete_request, :ignore_request]

  # GET /work_logs
  # GET /work_logs.json
  def index
    @work_logs = WorkLog.active
  end

  # GET /work_logs/1
  # GET /work_logs/1.json
  def show
    @tasks = current_user.assigned_and_written_tasks.pending.paginate(page: params[:page], per_page: 10)
    @fin_tasks = current_user.watching_tasks.completed.paginate(page: params[:page], per_page: 10) unless params[:page]
  end

  # GET /work_logs/new
  def new
    unless params[:date].present?
      @date = Date.today
    else
      @date = params[:date].to_date
    end
    @entries = current_user.assignments.where('tasks.start_date <= ? && tasks.end_date >= ?', @date.end_of_day, @date.beginning_of_day)
    @date = params[:date].present? ? params[:date].to_date : Date.today
    @work_log = WorkLog.new(:date => @date)
    @hours = @work_log.minutes.to_i/60
    @mins = @work_log.minutes.to_i%60
  end

  # GET /work_logs/1/edit
  def edit
    @date = @work_log.date
    @entries = Task.where('start_date <= ? && end_date >= ?', @work_log.date.end_of_day, @work_log.date.beginning_of_day)
    @hours = @work_log.minutes.to_i/60
    @mins = @work_log.minutes.to_i%60
  end

  # POST /work_logs
  # POST /work_logs.json
  def create
    @work_log = WorkLog.new(work_log_params)
    @work_log.user_id = current_user.id
    @work_log.minutes = params[:work_log][:hours].to_i*60+params[:work_log][:mins].to_i
    unless params[:date].present?
      @date = Date.today
    else
      @date = params[:date].to_date
    end
    @entries = current_user.assignments.where('tasks.start_date <= ? && tasks.end_date >= ?', @date.end_of_day, @date.beginning_of_day)
    @date = params[:date].present? ? params[:date].to_date : Date.today
    @hours = @work_log.minutes.to_i/60
    @mins = @work_log.minutes.to_i%60
    respond_to do |format|
      if @work_log.save
        format.html { redirect_to @work_log, notice: 'Work log was successfully created.' }
        format.json { render action: 'show', status: :created, location: @work_log }
        format.js { render :layout => false }
      else
        format.js { render :layout => false }
        format.html { render action: 'new' }
        format.json { render json: @work_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /work_logs/1
  # PATCH/PUT /work_logs/1.json
  def update
    @work_log.minutes = params[:work_log][:hours].to_i*60+params[:work_log][:mins].to_i
    respond_to do |format|
      if @work_log.update(work_log_params)
        format.html { redirect_to @work_log, notice: 'Work log was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @work_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /work_logs/1
  # DELETE /work_logs/1.json
  def destroy
    if @work_log.user == current_user && @work_log.date >= 4.days.ago
      @work_log.destroy
    elsif @work_log.user == current_user
      flash[:notice] = "Log is older than 5 days"
    elsif current_user.manager?
      flash[:notice] = "Worklog deleted"
      @work_log.destroy
    else
      flash[:notice] = "Permission denied"
    end
    respond_to do |format|
      unless current_user.manager?
        format.html { redirect_to root_url }
      else
        format.html { redirect_to reports_worklogs_path }
      end
      format.json { head :no_content }
    end
  end

  def delete_request
    if @work_log.user_id == current_user.id and @work_log.update_attribute(:delete_request,true)
      flash[:notice] = "Delete Request has been made."
    else
      flash[:notice] = "Delete Request could not be made."
    end
    respond_to do |format|
      format.html { redirect_to reports_worklogs_path }
      format.json { head :no_content }
    end
  end

  def ignore_request
    if current_user.manager? and @work_log.update_attribute(:delete_request,false)
      flash[:notice] = "Delete Request has been ignored."
    else
      flash[:notice] = "Delete Request could not be ignored."
    end
    respond_to do |format|
      format.html { redirect_to reports_worklogs_path }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_work_log
    @work_log = WorkLog.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def work_log_params
    params.require(:work_log).permit(:user_id, :name, :description, :start_time, :date, :end_time, :is_deleted, :task_id, :delete_request)
  end
end
