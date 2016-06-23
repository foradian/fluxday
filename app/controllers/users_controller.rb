class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  # GET /users
  # GET /users.json
  def index
    @users = User.active.by_name
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @teams = @user.teams
    @managers = @user.managers
    @users = User.active.by_name
  end

  # GET /users/new
  def new
    @user = User.new
    @users = User.active.by_name
  end

  # GET /users/1/edit
  def edit
    @users = User.active.by_name
    @user_role = @user.role  == "admin" ? "Manager" : @user.role
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @users = User.active.by_name

    respond_to do |format|
      if @user.save
        p '.............................'
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        p '.............................'
        p @user.errors.full_messages
        p '.............................'
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @users = User.active.by_name
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    if @user.update_attribute(:is_deleted, true)
      @user.project_managers.update_all(:status => 'archived')
      @user.team_members.update_all(:status => 'archived')
      @user.reporting_managers.update_all(:status => 'archived')
      @user.reporting_employees.update_all(:status => 'archived')
    end
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  def change_password
    @user = current_user
    @users = User.active.by_name
    if request.post?
      if @user.update(user_params)
        respond_to do |format|
          format.html { redirect_to @user, notice: 'User was successfully updated.' }
          format.json { head :no_content }
        end
      else
        respond_to do |format|
          format.html { render 'change_password'}
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.friendly.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :role, :nickname, :employee_code, :image, :manager_ids => [])
  end
end
