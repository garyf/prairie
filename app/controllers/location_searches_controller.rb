class LocationSearchesController < SearchesController

  respond_to :html

  def index
    cache_read(session[:location_search_key], new_location_search_path, Location)
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
      @search_results_for_page = []
      render :index
    end
  end
end
