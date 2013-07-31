class PersonSearchesController < ApplicationController

  respond_to :html

  def index
    redirect_to new_person_search_path
  end

  def new
    @field_sets = PersonFieldSet.by_name
  end

  def create
    @people = PersonSearch.new.people(params)
    render :index
  end
end
