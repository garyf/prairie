class PeopleController < ApplicationController

  before_action :person_assign, only: [:show, :edit, :update, :destroy]
  before_action :education_levels_assign, only: [:new, :edit]
  respond_to :html

  def index
    @people = Person.by_name_last(params[:page])
  end

  def show
    @field_sets = PersonFieldSet.enabled_by_name
  end

  def new
    @person = Person.new
  end

  def edit
  end

  def create
    @person = Person.new(params_white)
    redirect_to(@person, notice: 'Person successfully created') and return if @person.save
    education_levels_assign
    flash[:alert] = 'Failed to create person'
    render :new
  end

  def update
    redirect_to(@person, notice: 'Person successfully updated') and return if @person.update(params_white)
    education_levels_assign
    flash[:alert] = 'Failed to update person'
    render :edit
  end

  def destroy
    @person.garbage_collect_and_self_destroy
    redirect_to people_path, notice: 'Person successfully destroyed'
  end

private

  def person_assign
    @person = Person.find(params[:id])
  end

  def education_levels_assign
    @education_levels = EducationLevel.by_row
  end

  def params_white
    params.require(:person).permit(
      :birth_year,
      :education_level_id,
      :email,
      :height,
      :male_p,
      :name_first,
      :name_last)
  end
end
