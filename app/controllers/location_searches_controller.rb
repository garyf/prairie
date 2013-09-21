class LocationSearchesController < ApplicationController

  respond_to :html

  def index
    key = session[:location_search_key]
    redirect_to new_location_search_path and return unless key && params[:page]
    @search_cache = SearchCache.new(key)
    @locations = Location.search_results_fetch(@search_cache, params[:page])
    redirect_to new_location_search_path and return if @locations.empty?
    @results_count = @search_cache.result_ids_count
  end

  def new
    @field_sets = LocationFieldSet.enabled_by_name
  end

  def create
    key = LocationSearch.new.result_ids_store(session[:location_search_key], params)
    if key
      session[:location_search_key] = key
      redirect_to location_searches_path(page: '1')
    else
      session[:location_search_key] = nil
      @locations = []
      render :index
    end
  end
end
