class LocationsController < ApplicationController

  before_action :location_assign, only: [:show, :edit, :update, :destroy]
  respond_to :html

  def index
    @locations = Location.by_name(params[:page])
  end

  def show
    @field_sets = LocationFieldSet.by_name
  end

  def new
    @location = Location.new
  end

  def edit
  end

  def create
    @location = Location.new(params_white)
    flash[:notice] = 'Location successfully created' if @location.save
    respond_with @location
  end

  def update
    flash[:notice] = 'Location successfully updated' if @location.update(params_white)
    respond_with @location
  end

  def destroy
    @location.custom_fields_garbage_collect_and_self_destroy
    redirect_to locations_path, notice: 'Location successfully destroyed'
  end

private

  def location_assign
    @location = Location.find(params[:id])
  end

  def params_white
    params.require(:location).permit(
      :description,
      :name)
  end
end
