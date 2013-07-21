class FieldSetsController < ApplicationController
  
  before_action :field_set_assign, only: [:show, :edit, :update, :destroy]
  respond_to :html

  def index
    @field_sets = FieldSet.by_name
  end

  def show
    @custom_fields = @field_set.custom_fields
  end

  def new
    @field_set = FieldSet.subklass(params[:kind])
  end

  def edit
  end

  def create
    @field_set = FieldSet.subklass_with(params_white)
    if @field_set.save
      redirect_to field_sets_path, notice: 'Field set successfully created'
    else
      flash[:alert] = 'Failed to create field set'
      render :new
    end
  end

  def update
    if @field_set.update(params_white)
      redirect_to field_sets_path, notice: 'Field set successfully updated'
    else
      flash[:alert] = 'Failed to update field set'
      render :edit
    end
  end

  def destroy
    @field_set.destroy
    redirect_to field_sets_path, notice: 'Field set successfully destroyed'
  end

private

  def field_set_assign
    @field_set = FieldSet.find(params[:id])
  end

  def params_white
    params.require(:field_set).permit(
      :description,
      :name,
      :type)
  end
end
