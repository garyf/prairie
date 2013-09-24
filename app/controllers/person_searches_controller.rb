class PersonSearchesController < SearchesController

  respond_to :html

  def index
    cache_read(Person, session[:person_search_key], new_person_search_path)
  end

  def new
    @education_levels = EducationLevel.by_row
    @field_sets = PersonFieldSet.enabled_by_name
  end

  def create
    cache_write(PersonSearch, :person_search_key, person_searches_path(page: '1'))
  end
end
