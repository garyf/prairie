class PeopleController < ApplicationController

  before_action :person_assign, only: [:show, :edit, :update, :destroy]
  respond_to :html

  def index
    @people = Person.by_name_last(params[:page])
  end

  def show
    @field_sets = PersonFieldSet.by_name
  end

  def new
    @person = Person.new
  end

  def edit
  end

  def create
    @person = Person.new(params_white)
    flash[:notice] = 'Person successfully created' if @person.save
    respond_with @person
  end

  def update
    flash[:notice] = 'Person successfully updated' if @person.update(params_white)
    respond_with @person
  end

  def destroy
    @person.garbage_collect_and_self_destroy
    redirect_to people_path, notice: 'Person successfully destroyed'
  end

private

  def person_assign
    @person = Person.find(params[:id])
  end

  def params_white
    params.require(:person).permit(
      :email,
      :name_first,
      :name_last)
  end
end
