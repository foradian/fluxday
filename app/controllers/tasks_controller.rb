class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  load_and_authorize_resource
  #load_and_authorize_resource :task, :through => [:team,:task], :shallow => true

  # GET /tasks
  # GET /tasks.json
  def index
    #@tasks = current_user.assignments
    @tasks = current_user.assigned_and_written_tasks
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    @tasks = current_user.assigned_and_written_tasks
    @team = @task.team
    @project = @team.project
    @sub_tasks = @task.sub_tasks
    @comment = @task.comments.new
  end

# GET /tasks/new
  def new
    @root_task = Task.find(params[:task_id]) if params[:task_id].present?
    @task = @root_task.present? ? @root_task.sub_tasks.new : Task.new
    @task.start_date = Time.now
    @task.end_date = Time.now
    if params[:team_id].present?
      @team = Team.find(params[:team_id])
      @task.team_id = @team.id if @team.present?
      @task.project_id = @team.project_id if @team.present?
    end
    @projects = Project.active
    @teams = Team.for_user(current_user)
    @team ||= @teams.first
    @users = @team.members if @team
    @kr_ids = @task.key_result_ids
    @key_results = @team.key_results.where('key_results.start_date <= ? && key_results.end_date >= ?', @task.end_date, @task.start_date).group_by(&:user_id) if @team
  end

  # GET /tasks/1/edit
  def edit
    @projects = Project.active
    @teams = Team.for_user(current_user)
    @team ||= @task.team
    @users = @team.try(&:members)
    start_date = @task.start_date
    end_date = @task.end_date
    @kr_ids = @task.key_result_ids
    @key_results = @team.key_results.where('key_results.start_date <= ? && key_results.end_date >= ?', end_date, start_date).group_by(&:user_id)
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)
    @task.project_id = @task.team.project_id if @task.team.present?
    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: 'Task was successfully created.' }
        format.json { render action: 'show', status: :created, location: @task }
      else
        format.html { render action: 'new' }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.update_attribute(:is_deleted,true)
    respond_to do |format|
      format.html { redirect_to tasks_url }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def task_params
    params.require(:task).permit(:name, :description, :start_date, :task_id, :end_date, :project_id, :team_id, :user_id, :tracker_id, :priority, :comments_count, :key_result_ids=>[],:user_ids => [])
  end
end
