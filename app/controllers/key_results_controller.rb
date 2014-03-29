class KeyResultsController < ApplicationController
  before_action :set_key_result, only: [:show, :edit, :update, :destroy]

  # GET /key_results
  # GET /key_results.json
  def index
    @key_results = KeyResult.all
  end

  # GET /key_results/1
  # GET /key_results/1.json
  def show
  end

  # GET /key_results/new
  def new
    @key_result = KeyResult.new
  end

  # GET /key_results/1/edit
  def edit
  end

  # POST /key_results
  # POST /key_results.json
  def create
    @key_result = KeyResult.new(key_result_params)

    respond_to do |format|
      if @key_result.save
        format.html { redirect_to @key_result, notice: 'Key result was successfully created.' }
        format.json { render action: 'show', status: :created, location: @key_result }
      else
        format.html { render action: 'new' }
        format.json { render json: @key_result.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /key_results/1
  # PATCH/PUT /key_results/1.json
  def update
    respond_to do |format|
      if @key_result.update(key_result_params)
        format.html { redirect_to @key_result, notice: 'Key result was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @key_result.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /key_results/1
  # DELETE /key_results/1.json
  def destroy
    @key_result.destroy
    respond_to do |format|
      format.html { redirect_to key_results_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_key_result
      @key_result = KeyResult.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def key_result_params
      params.require(:key_result).permit(:name, :user_id, :objective_id, :author_id, :start_date, :end_date)
    end
end
