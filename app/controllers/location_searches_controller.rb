class LocationSearchesController < SearchesController

  respond_to :html

  def index
    cache_read(Location, session[:location_search_key], new_location_search_path)
  end

  def new
    @field_sets = LocationFieldSet.enabled_by_name
  end

  def create
    cache_write(LocationSearch, :location_search_key, location_searches_path(page: '1'))
  end
end
