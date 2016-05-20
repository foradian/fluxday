class OauthApplicationsController < ApplicationController
  before_action :set_oauth_application, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource :oauth_application

  # GET /oauth_applications
  # GET /oauth_applications.json
  def index
    @oauth_applications = OauthApplication.by_name.all
    @oauth_application = @oauth_applications.first
    @users = @oauth_application.users if @oauth_applications.present?
  end

  # GET /oauth_applications/1
  # GET /oauth_applications/1.json
  def show
    @oauth_application = OauthApplication.find(params[:id])
    @users = @oauth_application.users
  end

  # GET /oauth_applications/new
  def new
    @oauth_application = OauthApplication.new
    @oauth_applications = OauthApplication.all.by_name
  end

  # GET /oauth_applications/1/edit
  def edit
    @oauth_application = OauthApplication.find(params[:id])
    @oauth_applications = OauthApplication.all.by_name
    @user_ids = @oauth_application.user_ids
  end

  # POST /oauth_applications
  # POST /oauth_applications.json
  def create
    @oauth_application = Doorkeeper::Application.new(oauth_application_params.except('user_ids'))
    @oauth_applications = OauthApplication.all.by_name
    @user_ids =  oauth_application_params[:user_ids]
    respond_to do |format|
      if @oauth_application.save
        OauthApplication.find(@oauth_application.id).update_attributes('user_ids'=>oauth_application_params[:user_ids])
        format.html { redirect_to oauth_application_path(@oauth_application), notice: 'Oauth application was successfully created.' }
        format.json { render action: 'show', status: :created, location: @oauth_application }
      else
        format.html { render action: 'new' }
        format.json { render json: @oauth_application.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /oauth_applications/1
  # PATCH/PUT /oauth_applications/1.json
  def update
    respond_to do |format|
      if @oauth_application.update(oauth_application_params.except('user_ids'))
        OauthApplication.find(@oauth_application.id).update_attributes('user_ids'=>oauth_application_params[:user_ids])
        format.html { redirect_to oauth_application_path(@oauth_application), notice: 'Oauth application was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @oauth_application.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /oauth_applications/1
  # DELETE /oauth_applications/1.json
  def destroy
    @oauth_application.destroy
    respond_to do |format|
      format.html { redirect_to oauth_applications_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_oauth_application
      @oauth_application = OauthApplication.find(params[:id])
      @oauth_applications = OauthApplication.all.by_name
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def oauth_application_params
      params.require(:oauth_applications).permit(:name, :redirect_uri, :user_ids => [])
    end
end
