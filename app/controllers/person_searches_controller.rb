class PersonSearchesController < ApplicationController

  respond_to :html

  def index
    key = session[:person_search_key]
    redirect_to new_person_search_path and return unless key && params[:page]
    @people = PersonSearch.people_fetch(key, params[:page])
  end

  def new
    @field_sets = PersonFieldSet.enabled_by_name
  end

  def create
    key = PersonSearch.new.result_ids_store(session[:person_search_key], params)
    if key
      session[:person_search_key] = key
      redirect_to person_searches_path(page: '1')
    else
      session[:person_search_key] = nil
      @people = []
      render :index
    end
  end
end
