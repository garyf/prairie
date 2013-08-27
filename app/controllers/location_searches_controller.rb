class LocationSearchesController < ApplicationController

  respond_to :html

  def index
    redirect_to new_location_search_path
  end

  def new
    @field_sets = LocationFieldSet.by_name
  end

  def create
    @locations = LocationSearch.new.results_find(params)
    render :index
  end
end
