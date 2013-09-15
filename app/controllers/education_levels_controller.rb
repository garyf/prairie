class EducationLevelsController < ApplicationController

  before_action :education_level_assign, only: [:show, :edit, :update, :destroy]
  respond_to :html

  def index
    @education_levels = EducationLevel.by_row
  end

  def new
    @education_level = EducationLevel.new
  end

  def edit
    @row_edit_able_p = EducationLevel.row_edit_able?
  end

  def create
    @education_level = EducationLevel.new(params_white)
    if @education_level.save
      redirect_to education_levels_path, notice: 'Education level successfully created'
    else
      flash[:alert] = 'Failed to create education level'
      render :new
    end
  end

  def update
    if @education_level.update(params_white_w_human_row)
      redirect_to education_levels_path, notice: 'Education level successfully updated'
    else
      flash[:alert] = 'Failed to update education level'
      render :edit
    end
  end

  def destroy
    redirect_to root_path and return unless @education_level.destroyable?
    @education_level.destroy
    redirect_to education_levels_path, notice: 'Education level successfully destroyed'
  end

private

  def education_level_assign
    @education_level = EducationLevel.find(params[:id])
  end

  def params_white
    params.require(:education_level).permit(
      :description,
      :name,
      :row_position)
  end
end
