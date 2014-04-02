class ObjectivesController < ApplicationController
  before_action :set_objective, only: [:show, :edit, :update, :destroy]
  before_action :date_and_user, only: [:new, :edit, :index]

  layout 'less_pane'

  # GET /objectives
  # GET /objectives.json

  def index
    @users=User.active
    @objectives = @user.objectives.includes(:key_results)
  end

  # GET /objectives/1
  # GET /objectives/1.json
  def show
  end

  # GET /objectives/new
  def new
    @objective = @user.objectives.new(:start_date=>@start_date,:end_date=>@end_date)
    @objective.key_results.build
  end

  # GET /objectives/1/edit
  def edit

  end

  # POST /objectives
  # POST /objectives.json
  def create
    @objective = Objective.new(objective_params)

    respond_to do |format|
      if @objective.save
        format.html { redirect_to @objective, notice: 'Objective was successfully created.' }
        format.json { render action: 'show', status: :created, location: @objective }
      else
        format.html { render action: 'new' }
        format.json { render json: @objective.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /objectives/1
  # PATCH/PUT /objectives/1.json
  def update
    respond_to do |format|
      if @objective.update(objective_params)
        format.html { redirect_to @objective, notice: 'Objective was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @objective.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /objectives/1
  # DELETE /objectives/1.json
  def destroy
    @objective.destroy
    respond_to do |format|
      format.html { redirect_to objectives_url }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_objective
    @objective = Objective.find(params[:id])
  end

  def date_and_user
    @user = User.find(params[:user_id]) if params[:user_id]
    @user ||= current_user
    @start_date = params[:start_date] if params[:start_date]
    @start_date ||= Date.today.to_quarters[0]
    @end_date = params[:end_date] if params[:end_date]
    @end_date ||= Date.today.to_quarters[1]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def objective_params
    params.require(:objective).permit(:name, :user_id, :author_id, :start_date, :end_date,key_results_attributes: [:id, :name, :objective_id, :start_date, :end_date, :user_id, :_destroy])
  end
end
