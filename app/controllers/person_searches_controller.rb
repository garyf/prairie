class PersonSearchesController < ApplicationController

  respond_to :html

  def index
    redirect_to new_person_search_path
  end

  def new
    @field_sets = PersonFieldSet.by_name
  end

  def create
    @people = PersonSearch.new.results_find(params)
    render :index
  end
end
