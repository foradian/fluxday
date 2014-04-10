class OkrsController < ApplicationController
  before_action :set_okr, only: [:show, :edit, :update, :destroy]
  before_action :date_and_user, only: [:new, :edit, :index, :show, :create, :update]

  # GET /okrs
  # GET /okrs.json
  def index
    @okrs = @user.okrs.active.includes([:objectives => [:key_results]])
    @okr = @okrs.first
  end

  # GET /okrs/1
  # GET /okrs/1.json
  def show
    @user = @okr.user
    @okrs = @user.okrs.active.includes([:objectives => [:key_results]])
  end

  # GET /okrs/new
  def new
    @okr = Okr.new(:user_id => @user.id, :start_date => @start_date, :end_date => @end_date)
    @okr.objectives.build
    2.times { @okr.objectives.first.key_results.build }
  end

  # GET /okrs/1/edit
  def edit
    @okrs = @user.okrs.active.includes([:objectives => [:key_results]])
  end

  # POST /okrs
  # POST /okrs.json
  def create
    @okr = Okr.new(okr_params)

    respond_to do |format|
      if @okr.save
        format.html { redirect_to user_okr_path(@okr.user_id, @okr), notice: 'Okr was successfully created.' }
        format.json { render action: 'show', status: :created, location: @okr }
      else
        format.html { render action: 'new' }
        format.json { render json: @okr.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /okrs/1
  # PATCH/PUT /okrs/1.json
  def update
    respond_to do |format|
      if @okr.update(okr_params)
        format.html { redirect_to user_okr_path(@okr.user_id, @okr), notice: 'Okr was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @okr.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /okrs/1
  # DELETE /okrs/1.json
  def destroy
    @okr.destroy
    respond_to do |format|
      format.html { redirect_to okrs_url }
      format.json { head :no_content }
    end
  end

  def approve
    @okr= Okr.find(params[:id])
    if (current_user.user_ids.include?(@okr.user_id) || current_user.manager?)
      @okr.update_attributes(:approved=>true)
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_okr
    @okr = Okr.find(params[:id])
  end

  def date_and_user
    @user = User.friendly.find(params[:user_id]) if params[:user_id]
    @user ||= current_user
    @user ||= User.find(params[:okr][:user_id]) if (params[:okr] && params[:okr][:user_id].present?)
    @start_date = params[:start_date] if params[:start_date]
    @start_date ||= Date.today.to_quarters[0]
    @end_date = params[:end_date] if params[:end_date]
    @end_date ||= Date.today.to_quarters[1]
    unless (@user.id == current_user.id || current_user.user_ids.include?(@user.id) || current_user.manager?)
      redirect_to root_path, :alert => 'Unauthorized access'
    end
    @okrs = @user.okrs.active.includes([:objectives => [:key_results]])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def okr_params
    params.require(:okr).permit(:user_id, :name, :start_date, :end_date, objectives_attributes: [:id, :name, :okr_id, :start_date, :end_date, :user_id, :_destroy, key_results_attributes: [:id, :name, :objective_id, :start_date, :end_date, :user_id, :_destroy]])
  end
end
