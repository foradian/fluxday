class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  #before_filter :authenticate_user!
  load_and_authorize_resource

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.active
    @project = @projects.first unless @projects.empty?
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @projects = Project.active
    @teams = @project.teams
    @managers = @project.users.by_name
    @members = @project.members.where('').map{|x| x}.sort{|a,b| a.name<=>b.name}
  end

  # GET /projects/new
  def new
    @projects = Project.active
    @project = Project.new
    @users= User.active
  end

  # GET /projects/1/edit
  def edit
    @projects = Project.active

    @users= User.active
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
    @users= User.active

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render action: 'show', status: :created, location: @project }
      else
        format.html { render action: 'new' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    @users= User.active
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def project_params
    params.require(:project).permit! #(:name, :code, :description, :is_deleted, :team_count, :member_count, :website, :image)
    #params.require(:project).permit(:name, :code, :description, :is_deleted, :team_count, :member_count, :website, :image)
  end
end
