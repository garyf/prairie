class PersonSearchesController < SearchesController

  respond_to :html

  def index
    cache_read(session[:person_search_key], new_person_search_path, Person)
  end

  def new
    @education_levels = EducationLevel.by_row
    @field_sets = PersonFieldSet.enabled_by_name
  end

  def create
    key = PersonSearch.new.result_ids_store(session[:person_search_key], params)
    if key
      session[:person_search_key] = key
      redirect_to person_searches_path(page: '1')
    else
      session[:person_search_key] = nil
      @search_results_for_page = []
      render :index
    end
  end
end
