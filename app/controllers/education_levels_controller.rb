class EducationLevelsController < ApplicationController
  before_action :set_education_level, only: [:show, :edit, :update, :destroy]

  # GET /education_levels
  # GET /education_levels.json
  def index
    @education_levels = EducationLevel.all
  end

  # GET /education_levels/1
  # GET /education_levels/1.json
  def show
  end

  # GET /education_levels/new
  def new
    @education_level = EducationLevel.new
  end

  # GET /education_levels/1/edit
  def edit
  end

  # POST /education_levels
  # POST /education_levels.json
  def create
    @education_level = EducationLevel.new(education_level_params)

    respond_to do |format|
      if @education_level.save
        format.html { redirect_to @education_level, notice: 'Education level was successfully created.' }
        format.json { render action: 'show', status: :created, location: @education_level }
      else
        format.html { render action: 'new' }
        format.json { render json: @education_level.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /education_levels/1
  # PATCH/PUT /education_levels/1.json
  def update
    respond_to do |format|
      if @education_level.update(education_level_params)
        format.html { redirect_to @education_level, notice: 'Education level was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @education_level.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /education_levels/1
  # DELETE /education_levels/1.json
  def destroy
    @education_level.destroy
    respond_to do |format|
      format.html { redirect_to education_levels_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_education_level
      @education_level = EducationLevel.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def education_level_params
      params.require(:education_level).permit(:name, :description, :row)
    end
end
